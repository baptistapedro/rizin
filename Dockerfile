FROM ubuntu:latest
RUN apt-get update
RUN apt install -y build-essential wget git  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev  python3 python3-pip python3-dev libssl-dev \
cmake clang meson ninja-build afl
WORKDIR /
RUN git clone https://github.com/rizinorg/rizin.git
WORKDIR /rizin
RUN CC=afl-clang CXX=afl-clang++ meson build .
RUN ninja -C build
RUN ninja -C build install
RUN mkdir /rizinCorpus
RUN cp /usr/bin/whoami /rizinCorpus
RUN cp /usr/bin/echo /rizinCorpus
#RUN cp /usr/bin/xxd /rizinCorpus
RUN cp /usr/bin/grep /rizinCorpus
ENV LD_LIBRARY_PATH=/usr/local/lib

#docker run pedbap/rizin-fuzz:2
ENTRYPOINT ["afl-fuzz", "-i", "/rizinCorpus", "-o", "/rizinOut"]
CMD ["/usr/local/bin/rizin", "@@"]
