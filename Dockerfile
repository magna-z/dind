FROM docker:dind

COPY dockerd-start.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/dockerd-start.sh

ENTRYPOINT ["dockerd-start.sh"]
