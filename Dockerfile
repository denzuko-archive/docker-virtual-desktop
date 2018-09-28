FROM alpine:latest

ARG HDD_SIZE=512M
ENV HDD_SIZE $HDD_SIZE

ARG RAM_SIZE=1024M
ENV RAM_SIZE $RAM_SIZE

ARG BOOTDISK=https://distro.ibiblio.org/tinycorelinux/9.x/x86/release/CorePlus-current.iso
ENV BOOTDISK $BOOTDISK

ARG KVM_ARCH=x86_64
ENV KVM_ARCH $KVM_ARCH

LABEL com.dwightaspencer.schema.docker.cmd="docker run -ti -p 5905/tcp --rm denzuko/docker-virtual-desktop:latest"

ADD $BOOTDISK /bootdisk.iso 

RUN apk add --no-cache qemu-img \
  qemu-system-or32 \
  qemu-system-mips64el \
  qemu-system-ppc64 \
  qemu-system-arm \
  qemu-system-sh4eb \
  qemu-system-xtensa \
  qemu-system-sparc64 \
  qemu-system-lm32 \
  qemu-system-mipsel \
  qemu-system-cris \
  qemu-system-alpha \
  qemu-system-ppc \
  qemu-system-unicore32 \
  qemu-system-microblaze \
  qemu-system-m68k \
  qemu-system-x86_64 \
  qemu-system-aarch64 \
  qemu-system-ppcemb \
  qemu-system-i386 \
  qemu-system-xtensaeb \
  qemu-system-mips64 \
  qemu-system-moxie \
  qemu-system-s390x \
  qemu-system-tricore \
  qemu-system-mips \
  qemu-system-microblazeel \
  qemu-system-sh4 \
  qemu-system-sparc && \
  qemu-img create -f qcow2 /hdd.qcow2 ${HDD_SIZE}

ENTRYPOINT ["qemu-system-${KVM_ARCH}"]
CMD ["-boot", "d", "-cdrom", "/bootdisk.iso", "-m", "${RAM_SIZE}", "-vnc", ":5", "-net", "nic,model=e1000", "-net", "user", "/hdd.qcow2"]
