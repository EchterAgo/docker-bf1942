FROM ubuntu:20.04 AS build

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        unrar \
        p7zip-full \
        xz-utils

COPY assets /assets

ARG IPFS_GATEWAY=dweb.link

RUN /assets/download.sh

RUN mkdir - /bf1942

RUN echo "Installing Battlefield 1942 1.6-RC2 Server..." && \
    7z x /assets/cache/bf1942_lnxded-1.6-rc2.run -o/tmp > /dev/null && \
    tar -C /bf1942 -xf /tmp/bf1942_lnxded-1.6-rc2 && \
    rm /bf1942/license.sh && \
    ln -s bf1942_lnxded.static /bf1942/bf1942_lnxded && \
    rm /tmp/*

RUN echo "Installing Battlefield 1942 1.61 Server Update..." && \
    tar -C /bf1942 --strip-components=1 -xf /assets/cache/bf1942-update-1.61.tar.gz && \
    rm /bf1942/UPDATE-1.61-INSTALL.txt

RUN echo "Installing Battlefield 1942 Unofficial 1.612 20220223 Server Update..." && \
    7z x /assets/cache/bf1942_lnxded_1.612_patched_20220223.zip -o/tmp > /dev/null && \
    mv '/tmp/bf1942_lnxded - master.bf1942.org - Patch'/* /bf1942 && \
    chmod a+x /bf1942/bf1942_lnxded.* && \
    rm -rf '/tmp/bf1942_lnxded - master.bf1942.org - Patch'

RUN echo "Installing Maps from Doubti/Mourits..." && \
    7z x /assets/cache/all-server-maps.zip -o/tmp > /dev/null && \
    mv '/tmp/all-server-maps'/* /bf1942/mods/bf1942/archives/bf1942/levels && \
    rm -rf '/tmp/all-server-maps'

RUN echo "Installing Battlefield 1942 Server Manager 2.01..." && \
    tar -C /tmp -xf /assets/cache/BFServerManager201.tgz && \
    cp /tmp/bfsmd /bf1942 && \
    cp /tmp/bfsmd.static /bf1942 && \
    cp /tmp/*.con /bf1942/mods/bf1942/settings && \
    rm /tmp/*

RUN echo "Installing BFSM Internal Error! Patch by petr8..." && \
    cp /assets/cache/bfsmd.internal_err_patched /bf1942/bfsmd && \
    chmod +x /bf1942/bfsmd

RUN echo "Installing Punkbuster Fix by BF-League..." && \
    cd /tmp && \
    unrar x -idq '/assets/cache/pb-linuxserver-files.rar' && \
    cd - > /dev/null && \
    cp -R /tmp/pb-serverfiles/dll /bf1942/pb && \
    cp -R /tmp/pb-serverfiles/htm /bf1942/pb && \
    cp /tmp/pb-serverfiles/*.cfg /bf1942/pb && \
    cp /tmp/pb-serverfiles/*.so /bf1942/pb && \
    rm -rf /tmp/pb-serverfiles

RUN echo "Installing Desert Combat 0.7n Beta Server Files..." && \
    7z x /assets/cache/desertcombat_0.7n-beta_full_install.run -o/tmp > /dev/null && \
    tar -C /bf1942 -xf /tmp/desertcombat_0.7n-beta_full_install && \
    rm /tmp/*

RUN echo "Installing Desert Combat Final Server Files..." && \
    7z x /assets/cache/dc_final_server.run -o/tmp > /dev/null && \
    tar -C /bf1942/mods -xf /tmp/dc_final_server && \
    rm /tmp/*

FROM ubuntu:20.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++5:i386

COPY --from=build /bf1942/ /bf1942

WORKDIR /
COPY scripts/* /
RUN chmod +x /*.sh

# PORTS: Server, ASE, BFSM, GameSpy LAN, and GameSpy
EXPOSE 14567/udp 14690/udp 14667/udp 22000/udp 23000/udp

#COPY settings/* /bf1942/mods/bf1942/settings/

CMD /start.sh
