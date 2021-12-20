const { readFile, writeFile } = require('fs/promises');
const { CodeFile, ParsingHelper, IncludeStmt, ASTPrinter, FormattingConfiguration } = require('openscad-parser');
const { resolve, dirname, basename } = require('path');

/**
 * Reads an OpenSCAD source file, inlining any `include <...>` statements inline
 * @param {string} sourceFile Source filename
 * @returns {OpenSCADParser::AST} abstract syntax tree with all `include`s transcluded.
 **/
const scadSource = async (sourceFile) => {
  // Keep a log of what files have been included.
  const included = {};
  const getAST = async (sourceFile) => {
    included[resolve('.', sourceFile)] = true;
    const [ast, errorCollector] = ParsingHelper.parseFile(new CodeFile(sourceFile, await readFile(sourceFile, 'utf8')));
    errorCollector.throwIfAny();
    const output = [];
    for (let index = 0; index < ast.statements.length; index++) {
        const statement = ast.statements[index];
        if (statement instanceof IncludeStmt) {
          const path = resolve(dirname(statement.pos.file.path), statement.filename);
          // Don't double-include things.
          if (!included[path]) {
            output.push(...(await getAST(path)).statements);
          }
          continue;
        } else {
          output.push(statement);
          continue;
        }
    }
    ast.statements = output;
    return ast;
  };
  return await getAST(sourceFile, []);
};

if (process.argv.length !== 4) {
  throw new Error(`Usage: ${basename(process.argv[0])} ${basename(process.argv[1])} [entryPoint] [outputFile]`);
}
const [ entryPoint, outputFile ] = process.argv.slice(2);


(async () => {
  const transcluded = await scadSource(entryPoint);
  let output = new ASTPrinter(new FormattingConfiguration()).visitScadFile(transcluded);
  // Paste-over of [Issue #15](https://github.com/alufers/openscad-parser/issues/15)
  output = output
    .replace(/;[\s\t]*\n[\s\t]*\/\/(\s*\[|\d+)/g, '; //$1');
  await writeFile(outputFile, output, 'utf8');
})();