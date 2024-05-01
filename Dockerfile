FROM ubuntu as build
RUN apt-get update
RUN apt-get install -y \
    cpio \
    wget \
    xz-utils
RUN wget --quiet https://downloadgb.asustor.com/download/adm/X64_G3_3.5.3.RBH1.img
RUN wget --quiet https://master.dl.sourceforge.net/project/asgpl/ADM%202.0/Toolchain/x86_64-asustor-linux-gnu-64bit.tar.gz
RUN dd if=X64_G3_3.5.3.RBH1.img of=X64_G3_3.5.3.RBH1.tar iflag=skip_bytes skip=442 && \
    tar -xf X64_G3_3.5.3.RBH1.tar && \
    mv initramfs initramfs.xz && \
    xz -d initramfs.xz && \
    mkdir adm && \
    cd adm && \
    cpio -id < ../initramfs && \
    tar -xf ../builtin.tgz && \
    tar --strip-components=1 -xf ../x86_64-asustor-linux-gnu-64bit.tar.gz

FROM scratch
COPY --from=build /adm /
RUN /bin/busybox --install -s
CMD [ "/bin/sh", "-l" ]

