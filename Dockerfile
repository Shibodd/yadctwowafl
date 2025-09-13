FROM ubuntu:24.04


# Install LLVM
ARG LLVM_VERSION=21

RUN set -eux; \
    apt update && apt install -y lsb-release wget software-properties-common gnupg; \
    wget https://apt.llvm.org/llvm.sh; \
    chmod +x llvm.sh; \
    ./llvm.sh ${LLVM_VERSION} all; \
    rm ./llvm.sh; \
    # Make links for the LLVM Windows utils to avoid writing the LLVM version in the toolchain file
    update-alternatives --install /usr/bin/clang-cl clang-cl /usr/bin/clang-cl-${LLVM_VERSION} 100; \
    update-alternatives --install /usr/bin/llvm-lib llvm-lib /usr/bin/llvm-lib-${LLVM_VERSION} 100; \
    update-alternatives --install /usr/bin/lld-link lld-link /usr/bin/lld-link-${LLVM_VERSION} 100; \
    update-alternatives --install /usr/bin/llvm-mt llvm-mt /usr/bin/llvm-mt-${LLVM_VERSION} 100; \
    update-alternatives --install /usr/bin/llvm-rc llvm-rc /usr/bin/llvm-rc-${LLVM_VERSION} 100; \
    # Useful but inessential
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang-${LLVM_VERSION} 100; \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-${LLVM_VERSION} 100; \
    update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-${LLVM_VERSION} 100;

  
# Install Wine (not used at all in the build process - only useful for running the result)
RUN set -eux; \
    dpkg --add-architecture i386; \
    mkdir -pm755 /etc/apt/keyrings; \
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -; \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources; \
    apt update; \
    apt install -y --install-recommends winehq-stable


# Install a sysroot with Microsoft CRT and Windows SDK using xwin (https://github.com/Jake-Shadle/xwin/)
ENV WINDOWS_SYSROOT_PATH=/xwin
RUN set -eux; \
    apt update; \
    apt install -y rustup curl; \
    rustup default stable; \
    cargo install xwin; \
    # --preserve-ms-arch-notation is necessary for using the winsysroot flag during builds
    ~/.cargo/bin/xwin --temp --accept-license splat --use-winsysroot-style --preserve-ms-arch-notation --output "${WINDOWS_SYSROOT_PATH}"; \
    # cleanup
    apt remove -y rustup; \
    rm -rf ~/.cargo; \
    # Bug - https://github.com/Jake-Shadle/xwin/issues/146
    cd "${WINDOWS_SYSROOT_PATH}/Windows Kits/10/" && ln -s lib Lib && ln -s include Include;


# TODO: Install DIA SDK


# Install other utilities
RUN set -eux; \
    apt update; \
    apt install -y cmake ninja-build vim git;


# Create the user
ARG USER_UID=1000
ARG USER_GID=1000

RUN set -eux; \
    apt update && apt install sudo; \
    groupadd -g ${USER_GID} -o user; \
    useradd -m -u ${USER_UID} -g ${USER_GID} -d /home/user -s /bin/bash -o user; \
    sudo -u user mkdir -p /home/user; \
    echo user:user | chpasswd; \
    usermod -aG sudo user; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Init a wine prefix
RUN sudo -u user wine wineboot --init