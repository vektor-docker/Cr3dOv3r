FROM javister-docker-docker.bintray.io/javister/javister-docker-git:1.1 as GIT

RUN cd /app && \
    chmod 0777 /app && \
    SET_GIT_PROXY="yes" git-docker clone https://github.com/D4Vinci/Cr3dOv3r.git

FROM javister-docker-docker.bintray.io/javister/javister-docker-python3:34.1
MAINTAINER Viktor Verbitsky <vektory79@gmail.com>

COPY files /
COPY --from=GIT /app /app/

ENV HOME="/app"

RUN cd /app/Cr3dOv3r && \
    pip-docker install -r requirements.txt && \
    chmod --recursive --changes +x /etc/my_init.d/*.sh /etc/service /usr/local/bin

ENTRYPOINT ["my_init", "--skip-runit", "--", "Cr3dOv3r"]
CMD ["-h"]
