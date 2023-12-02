#!/usr/bin/env bash

function archive_python() {
  { #helpers
    archive_bin_files() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      declare -a iarr_bin_file=(
        "2to3-3.12"
        "idle3.12"
        "pip3.12"
        "pydoc3.12"
        "python3.12"
        "python3.12-config"
      )

      : "${path_tmp_directory}/bin"
      [[ -d "${_}" ]] || mkdir -p "${_}"

      for i in "${iarr_bin_file[@]}"; do
        cp -a \
          "${path_prefix_directory}/bin/${i}" \
          "${path_tmp_directory}/bin/${i}"
      done
    }

    archive_include_files() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      declare -a iarr_include_file=(
        "python3.12"
      )

      : "${path_tmp_directory}/include"
      [[ -d "${_}" ]] || mkdir -p "${_}"

      for i in "${iarr_include_file[@]}"; do
        cp -ar \
          "${path_prefix_directory}/include/${i}" \
          "${path_tmp_directory}/include/${i}"
      done
    }

    archive_lib_files() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      declare -a iarr_lib_file=(
        "libpython3.12.a"
        "pkgconfig"
        "python3.12"
      )

      : "${path_tmp_directory}/lib"
      [[ -d "${_}" ]] || mkdir -p "${_}"

      for i in "${iarr_lib_file[@]}"; do
        cp -ar \
          "${path_prefix_directory}/lib/${i}" \
          "${path_tmp_directory}/lib/${i}"
      done
    }

    archive_share_files() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      : "${path_tmp_directory}/share/man/man1"
      [[ -d "${_}" ]] || mkdir -p "${_}"

      cp -a \
        "${path_prefix_directory}/share/man/man1/python3.12.1" \
        "${path_tmp_directory}/share/man/man1/python3.12.1"
    }

    generate_archive_zip_file() {
      printf "\n\e[2;91m%s\n\n" "\$_ ${FUNCNAME[0]}"

      pushd "${path_tmp_directory}" >/dev/null || exit 1

      : "/root/data/python-${python_version}.zip"
      [[ -f "${_}" ]] && rm -f "${_}"

      zip -rq \
        "/root/data/python-${python_version}.zip" \
        .

      popd >/dev/null || exit 1

      rm -rf "${path_tmp_directory}"
    }
  }

  { #config
    declare \
      python_version="${python_version:+}" \
      path_prefix_directory="${path_prefix_directory:+}"

    declare -g \
      path_tmp_directory="${path_tmp_directory:+}"

    :

    python_version="3.12"

    ((EUID)) && { printf "\e[91m%s\e[0m\n" "You must run this script as root" && exit 1; }
    type -Pt "python${python_version}" >/dev/null || { printf "\e[91m%s\e[0m\n" "python${python_version} not found" && exit 1; }
    type -Pt "zip" >/dev/null || { printf "\e[91m%s\e[0m\n" "zip not found" && exit 1; }

    path_prefix_directory="/usr/local"
    path_tmp_directory="$(mktemp -d)"
  }

  :

  archive_bin_files
  archive_include_files
  archive_lib_files
  archive_share_files
  generate_archive_zip_file
}

archive_python
