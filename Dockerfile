FROM javister-docker-docker.bintray.io/javister/javister-docker-git:1.0 as GIT

RUN cd /app && \
    git-docker clone https://github.com/D4Vinci/Cr3dOv3r.git

FROM javister-docker-docker.bintray.io/javister/javister-docker-base:1.0
MAINTAINER Viktor Verbitsky <vektory79@gmail.com>

COPY files /
COPY --from=GIT /app /app/

ENV HOME="/app" \
    LOG_LEVEL="INFO" \
    RPMLIST="python34-pip"

RUN . /usr/local/bin/yum-proxy && \
    yum-install && \
    cd /app/Cr3dOv3r && \
    pip3 install -r requirements.txt && \
    yum-clean && \
    chmod --recursive --changes +x /etc/my_init.d/*.sh /etc/service /usr/local/bin

ENTRYPOINT ["my_init", "--skip-runit", "--", "Cr3dOv3r"]
CMD ["-h"]
