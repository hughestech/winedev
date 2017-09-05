FROM 32bit/ubuntu:16.04

RUN rm /etc/apt/sources.list
RUN apt-get update

#https://askubuntu.com/questions/760896/how-can-i-automatically-fix-w-target-packages-is-configured-multiple-times
#RUN sudo apt install python3-apt -y
#RUN wget https://raw.githubusercontent.com/davidfoerster/apt-remove-duplicate-source-entries/master/apt-remove-duplicate-source-entries.py
#RUN chmod +x apt-remove-duplicate-source-entries.p
#USER root
#RUN  ./apt-remove-duplicate-source-entries.py


ENV HOME="/home/builder"
RUN mkdir -p $HOME

RUN true \
    && apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
        ca-certificates \
        libarchive13 \
        libcurl3 \
        libexpat1 \
        libjsoncpp1 \
        librhash0 \
        libuv1 \
        make \
        runit \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Disable git warning about detached HEAD.
RUN buildDeps='git' \
    && apt-get -qq update \
    && apt-get -qq install -y $buildDeps --no-install-recommends \
    && git config --global advice.detachedHead false \
    && apt-get -qq purge --auto-remove -y $buildDeps \
    && rm -rf /var/lib/apt/lists/*

# Build and install ninja from source.
RUN buildDeps='g++ git python' \
    && apt-get -qq update \
    && apt-get -qq install -y $buildDeps --no-install-recommends \
    && git clone -b v1.7.2 --depth 1 https://github.com/martine/ninja.git \
    && cd ninja \
    && python configure.py --bootstrap \
    && mv ninja /usr/local/bin/ \
    && cd / \
    && rm -rf ninja \
    && apt-get -qq purge --auto-remove -y $buildDeps \
    && rm -rf /var/lib/apt/lists/*

# Build and install CMake from source.
RUN buildDeps=' \
        g++ \
        git \
        libarchive-dev \
        libcurl4-openssl-dev \
        libexpat1-dev \
        libjsoncpp-dev \
        librhash-dev \
        libuv1-dev \
        zlib1g-dev \
        ' \
    && apt-get -qq update \
    && apt-get -qq install -y $buildDeps --no-install-recommends \
    && git clone -b v3.8.1 --depth 1 git://cmake.org/cmake.git CMake \
    && cd CMake \
    && mkdir build \
    && cd build \
    && ../bootstrap \
        --parallel=$(nproc) \
        --prefix=/usr/local \
        --system-libs \
        --no-server \
    && make -j$(nproc) \
    && make install \
    && cd / \
    && rm -rf CMake \
    && apt-get -qq purge --auto-remove -y $buildDeps \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		g++ \
		flex \
		bison \
		libc6-dev \
		xz-utils \
      	wget \

	&& rm -rf /var/lib/apt/lists/*

#wine64 \
#		wine \
#		wine-development \
#      	wine64-development \
#     	#libwine-development \

RUN mkdir wine/

WORKDIR wine/

RUN wget   http://dl.winehq.org/wine/source/2.0/wine-2.0.2.tar.xz
RUN tar -xf wine-2.0.2.tar.xz

WORKDIR wine-2.0.2/

#RUN ./configure  --without-x  --without-freetype --enable-win64
RUN ./configure  --without-x  --without-freetype
RUN make
RUN make install

WORKDIR ../../wine/


ENV CC="/usr/local/bin/winegcc" \
    CXX="/usr/local/bin/wineg++"
