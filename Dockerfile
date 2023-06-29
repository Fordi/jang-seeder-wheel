FROM openscad/openscad

RUN apt update && \
  apt upgrade -y && \
  apt install jq -y

VOLUME /input
WORKDIR /input

CMD /bin/bash
