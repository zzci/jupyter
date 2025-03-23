FROM alpine:3.21 AS build

ENV VIRTUAL_ENV=/opt/jupyter
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN apk add python3 python3-dev py3-pip gcc musl-dev linux-headers

RUN python3 -m venv $VIRTUAL_ENV

RUN pip install jupyterlab

FROM alpine:3.21

COPY --from=docker /usr/local/bin/docker /usr/bin/docker
COPY --from=docker /usr/local/libexec/docker/cli-plugins/docker-compose /usr/lib/docker/cli-plugins/docker-compose

COPY --from=build /opt/jupyter /opt/jupyter

RUN apk add --no-cache curl git wget zsh bash xz coreutils python3 && \
    # on my zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    #
    ## croc
    curl https://getcroc.schollz.com | bash

ADD rootfs /

RUN \
    #
    ## pack /root
    mkdir -p /build/res/; \
    bash /tmp.sh; \
    touch /root/.init_tag_do_not_delete; \
    rm -rf /build/res/root.tar.gz; \
    tar -czf /build/res/root.tar.gz /root; \
    #
    ## fix permission
    chmod +x /opt/jupyter/start

WORKDIR /app

CMD [ "/opt/jupyter/start" ]
