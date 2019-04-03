FROM debian:stretch-slim

ARG DEBIAN_FRONTEND=noninteractive

ENV PUID=1000
ENV PGID=1000

RUN apt-get -qq update && \
	apt-get -qq upgrade && \
	apt-get -qq install \
		git \
		curl \
		gnupg2 \
		apt-utils \
		apt-transport-https \
	&& \
	apt-get -qq autoremove && \
	apt-get -qq clean

COPY start.sh /

###############################################
#        EDIT TEMPLATE AFTER THIS LINE        #
###############################################

RUN apt-get -qq install \
		golang-1.8 \
	&& \
	apt-get -qq autoremove && \
	apt-get -qq clean && \
	mkdir /go && \
	ln -s /usr/lib/go-1.8/bin/go /usr/local/bin/go

ENV GOPATH=/go
ENV PATH="${GOPATH}/bin:${PATH}"

#RUN go get -u -v github.com/ncw/rclone && \
#	chmod og+x /go/bin/rclone && \
#	echo "PATH=/go/bin:${PATH}" > /etc/environment

#RUN cd /tmp && \
#	git clone https://github.com/ncw/rclone.git && \
#	cd rclone && \
#	go build && \
#	./rclone version && \
#	mkdir -p ${GOPATH}/bin && \
#	echo "PATH=/go/bin:${PATH}" > /etc/environment && \
#	cp rclone ${GOPATH}/bin/rclone

RUN cd /tmp && \
	curl -L https://github.com/ncw/rclone/releases/download/v1.46/rclone-v1.46-linux-amd64.deb -O && \
	dpkg -i rclone-v1.46-linux-amd64.deb

ENV CONT_USER=rclone
ENV CONT_CMD="rclone"
ENV CONT_USER_HOME="/opt"

###############################################
#        EDIT TEMPLATE BEFORE THIS LINE       #
###############################################

RUN useradd -d $CONT_USER_HOME $CONT_USER

RUN chmod +x /start.sh

CMD ["/start.sh"]