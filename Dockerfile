FROM debian:stable-slim

ENV DOCKER_TEMPLATE_WRAPPER_HOME="/time-ghc-modules" \
    PROJECT_HOME="/project"

RUN mkdir $DOCKER_TEMPLATE_WRAPPER_HOME

ADD [ "./scripts", "${DOCKER_TEMPLATE_WRAPPER_HOME}/scripts" ]
ADD [ "./dist", "${DOCKER_TEMPLATE_WRAPPER_HOME}/dist" ]
COPY [ "./time-ghc-modules", "${DOCKER_TEMPLATE_WRAPPER_HOME}/" ]

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install sqlite3=3.* python3.6 python3-distutils python3-pip python3-apt && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  mkdir -p /root/db

RUN ln -s /usr/bin/python3 /usr/bin/python

VOLUME [ $PROJECT_HOME ]
WORKDIR $PROJECT_HOME

ENTRYPOINT [ "bash", "-c", "/time-ghc-modules/time-ghc-modules | xargs -I{} cp '{}' /project/report.html" ]

# docker run --rm -it -v $(pwd):/project time-ghc-modules
