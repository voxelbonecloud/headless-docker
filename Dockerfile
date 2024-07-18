FROM	ghcr.io/voxelbonecloud/debian-dotnet:main	

LABEL	author="Voxel Bone Cloud" maintainer="github@voxelbone.cloud"

RUN	apt update \
	&& dpkg --add-architecture i386 \
	&& apt install curl lib32gcc-s1 libfreetype6 -y \
	&& useradd -m -d /home/container -s /bin/bash container

COPY	./scripts /scripts

RUN	chmod +x /scripts/*

RUN	mkdir /Logs \
	&& chown -R container:container /Logs

RUN	mkdir -p /RML /RML/rml_mods /RML/rml_libs /RML/rml_config \
	&& chown -R container:container /RML
USER	container

USER	container
ENV	USER=container 
ENV	HOME=/home/container
ENV	DEBIAN_FRONTEND=noninteractive

WORKDIR	/home/container

STOPSIGNAL SIGINT

ENTRYPOINT ["/scripts/update-resonite.sh"]
CMD ["/scripts/launch-resonite.sh"]
