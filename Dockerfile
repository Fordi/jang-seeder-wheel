FROM openscad/openscad:dev

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install jq procps -y

VOLUME /input
WORKDIR /input

CMD /bin/bash
