FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends git openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config

# Missing privilege separation directory: /var/run/sshd

ENV PORT 22
EXPOSE $PORT

ENV WORKTREE "/parse/cloud"
ENV REPO_PATH "/parse-cloud-code"

ADD ssh-add-key /sbin/

RUN useradd -s /bin/bash git
RUN echo "git ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
