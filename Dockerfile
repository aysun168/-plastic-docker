FROM debian:stretch



RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container

CMD ["/bin/bash"]

LABEL maintainer="aysun168 <aysun168@gmail.com>"
LABEL contributor="aysun168"



RUN apt-get update && apt-get -y install sudo apt-transport-https ca-certificates
RUN apt-get -y install gnupg gnupg2 gnupg1 wget

USER root

CMD ["/bin/sh" "-c" "/bin/bash"]

RUN mkdir /conf
RUN mkdir /logs
RUN mkdir -p /db/jet

RUN echo "deb https://www.plasticscm.com/plasticrepo/stable/debian/ ./" >> /etc/apt/sources.list.d/plasticscm-stable.list


RUN DEBIAN_FRONTEND=noninteractive wget -q https://www.plasticscm.com/plasticrepo/stable/debian/Release.key -O - | sudo apt-key add -


RUN DEBIAN_FRONTEND=noninteractive sudo apt-get -q update && sudo apt-get install -y -q plasticscm-server-core && plasticsd stop


RUN { clconfigureserver --language=en --port=8087 --workingmode=UPWorkingMode; [ -f /opt/plasticscm5/server/users.conf ] && mv /opt/plasticscm5/server/users.conf /conf || touch /conf/users.conf; [ -f /opt/plasticscm5/server/groups.conf ] && mv /opt/plasticscm5/server/groups.conf /conf || touch /conf/groups.conf; mv /opt/plasticscm5/server/plasticd.lic /conf; ln -s /conf/users.conf /opt/plasticscm5/server && ln -s /conf/groups.conf /opt/plasticscm5/server; ln -s /conf/plasticd.lic /opt/plasticscm5/server; }


EXPOSE 7178
EXPOSE 8087

VOLUME /conf
VOLUME /db/conf
VOLUME /logs


CMD ["/opt/plasticscm5/server/plasticd", "--daemon"]
