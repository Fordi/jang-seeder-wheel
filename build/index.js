const { readFile, writeFile } = require('fs/promises');
const { CodeFile, ParsingHelper, IncludeStmt, ASTPrinter, FormattingConfiguration } = require('openscad-parser');
const { resolve, dirname, basename } = require('path');

const scadSource = async (sourceFile) => {
  const [ast, errorCollector] = ParsingHelper.parseFile(new CodeFile(sourceFile, await readFile(sourceFile, 'utf8')));
  errorCollector.throwIfAny();
  const output = [];
  for (let index = 0; index < ast.statements.length; index++) {
      const statement = ast.statements[index];
      if (statement instanceof IncludeStmt) {
        const path = resolve(dirname(statement.pos.file.path), statement.filename);
        output.push(...(await scadSource(path)).statements);
        continue;
      } else {
        output.push(statement);
        continue;
      }
  }
  ast.statements = output;
  return ast;
};

if (process.argv.length !== 4) {
  throw new Error(`Usage: ${basename(process.argv[0])} ${basename(process.argv[1])} [entryPoint] [outputFile]`);
}
const [ entryPoint, outputFile ] = process.argv.slice(2);


(async () => {
  const transcluded = await scadSource(entryPoint);
  const output = new ASTPrinter(new FormattingConfiguration()).visitScadFile(transcluded);
  await writeFile(outputFile, output, 'utf8');
})();