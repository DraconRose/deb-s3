FROM ubuntu:trusty
## SSH Stuff
RUN apt-get update \
  && apt-get install -y openssh-server acl \
  && mkdir /var/run/sshd \
  && (echo 'root:root' | chpasswd) \
  && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && echo 'UseDNS no' >> /etc/ssh/sshd_config \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
  && printf '#!/usr/bin/env bash\nservice ssh start\ntail -f /var/log/dmesg' > /start.sh
EXPOSE 22
CMD /start.sh

## Ruby stuff
# RUN 
COPY . /tmp/deb-s3
WORKDIR /tmp/deb-s3
RUN bundle install
# ENTRYPOINT [ "bundle", "exec", "deb-s3" ]

