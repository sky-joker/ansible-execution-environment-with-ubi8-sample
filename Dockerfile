FROM redhat/ubi8

ARG DUMP_INIT_VERSION="1.2.5"

COPY tools/requirements.txt /tmp/tools/requirements.txt

# update and install requirement packages
RUN dnf -y update && \
    dnf -y install gcc \
                   python39 \
                   python39-devel \
                   krb5-devel \
                   wget

RUN pip3 install --upgrade pip && \
    pip3 install -r /tmp/tools/requirements.txt

# In OpenShift, container will run as a random uid number and gid 0. Make sure things
# are writeable by the root group.
RUN for dir in \
      /home/runner \
      /home/runner/.ansible \
      /home/runner/.ansible/tmp \
      /runner \
      /home/runner \
      /runner/env \
      /runner/inventory \
      /runner/project \
      /runner/artifacts ; \
    do mkdir -m 0775 -p $dir ; chmod -R g+rwx $dir ; chgrp -R root $dir ; done && \
    for file in \
      /home/runner/.ansible/galaxy_token \
      /etc/passwd \
      /etc/group ; \
    do touch $file ; chmod g+rw $file ; chgrp root $file ; done

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMP_INIT_VERSION}/dumb-init_${DUMP_INIT_VERSION}_x86_64 && \
    chmod +x /usr/local/bin/dumb-init

WORKDIR /runner

ENV HOME=/home/runner

ADD utils/entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint

ENTRYPOINT ["entrypoint"]

CMD ["ansible-runner", "run", "/runner"]
