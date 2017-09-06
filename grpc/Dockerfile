FROM hughestech/grpcdev:wine32bit-1.0.0-alpha1

WORKDIR wine/

RUN apt-get install wget flex bison -y
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
