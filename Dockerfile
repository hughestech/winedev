# from https://github.com/purpleKarrot/build-containers/blob/master/mingw-w64-x86-64/Dockerfile
FROM purplekarrot/base:latest

# from https://github.com/tianon/dockerfiles/blob/master/wine/64/Dockerfile

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
#Commented out the below just to save time - use local resources instead
#RUN wget   http://dl.winehq.org/wine/source/2.0/wine-2.0.2.tar.xz
RUN tar -xf wine-2.0.2.tar.xz

WORKDIR wine-2.0.2/

RUN ./configure  --without-x  --without-freetype --enable-win64
RUN make
RUN make install

WORKDIR ../../wine/


ENV CC="/usr/bin/winegcc" \
    CXX="/usr/bin/wineg++"
