FROM ubuntu:24.04

# add missing dependencies needed by openframeworks
RUN apt-get update -y
RUN \
    # tzdata is installed later in install_dependencies script
    # but with interactive choices, so we configure it here correct
    DEBIAN_FRONTEND=noninteractive TZ=Europe/Berlin apt-get -y install \
        tzdata \
    # and also some other depedencies are missing
        lsb-release \
        make \
        git \
        curl \
        bash \
        libluajit-5.1-dev \
        liblua5.1-dev \
    # and to use sound also we need some more
    libpulse0 libasound2t64 libasound2-plugins alsa-base \
      && \
    # and clean up the apt cache
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y xz-utils

RUN curl -fsSL https://github.com/b1f6c1c4/git-get/releases/latest/download/git-get.tar.xz | /bin/tar -C /usr -xJv


ARG OF_SHA=dd1d70e


RUN git gets -H -v -Y  https://github.com/openFrameworks/openFrameworks/commit/${OF_SHA} -o of


# install of openframeworks dependencies
RUN of/scripts/linux/ubuntu/install_dependencies.sh && \
    of/scripts/linux/download_libs.sh  -a 64gcc6 && \
    rm -rf /var/lib/apt/lists/*

ARG OFXLUA_SHA=e41dc17

RUN git gets -H -v -Y  https://github.com/danomatika/ofxLua/commit/${OFXLUA_SHA} -o /of/addons/ofxLua
RUN cp -r of/addons/ofxLua/luaExample/ of/apps/myApps/luaExample/


# compile openframeworks
RUN /of/scripts/linux/compileOF.sh -j3
RUN cd of/scripts/linux && ./compilePG.sh 

RUN cd of/ && /of/apps/projectGenerator/commandLine/bin/projectGenerator -r -o"." examples

RUN cd of/ && /of/apps/projectGenerator/commandLine/bin/projectGenerator -r -o"." apps/myApps/luaExample/
RUN cd of/apps/myApps/luaExample/ && make

# WORKDIR /of/examples