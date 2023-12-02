#!/usr/bin/env bash

function compile_python() {
  { #helpers
    install_build_dependencies() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      export DEBIAN_FRONTEND=noninteractive

      echo "::group::${FUNCNAME[0]}"

      apt update -qq

      apt install -yqq \
        build-essential \
        libbz2-dev \
        libffi-dev \
        libgdbm-dev \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        make \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
        zip

      echo "::endgroup::"
    }

    download_python_source_code() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      echo "::group::${FUNCNAME[0]}"

      wget \
        --quiet \
        --no-verbose \
        --progress=bar:force:noscroll \
        --show-progress \
        "https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tar.xz"

      echo "::endgroup::"
    }

    extract_python_source_code() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      echo "::group::${FUNCNAME[0]}"

      tar -xvf "Python-${python_version}.tar.xz"

      echo "::endgroup::"
    }

    configure_python() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      cd "Python-${python_version}" || exit 1

      echo "::group::${FUNCNAME[0]}"

      ./configure --enable-optimizations

      echo "::endgroup::"
    }

    make_python() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      echo "::group::${FUNCNAME[0]}"

      make -j "$(nproc)"

      echo "::endgroup::"
    }

    install_python() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      echo "::group::${FUNCNAME[0]}"

      make altinstall

      echo "::endgroup::"
    }
  }

  { #config
    declare python_version="${python_version:+}"

    :

    python_version="3.12.0"

    ((EUID)) && { printf "\e[91m%s\e[0m\n" "You must run this script as root" && exit 1; }
  }

  :

  install_build_dependencies
  download_python_source_code
  extract_python_source_code
  configure_python
  make_python
  install_python
}

compile_python
