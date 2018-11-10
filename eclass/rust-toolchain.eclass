# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rust-toolchain.eclass
# @MAINTAINER:
# Rust Project <rust@gentoo.org>
# @SUPPORTED_EAPIS: 6
# @BLURB: helps map gentoo arches to rust ABIs
# @DESCRIPTION:
# This eclass contains a src_unpack default phase function, and
# helper functions, to aid in proper rust-ABI handling for various
# gentoo arches.

case ${EAPI} in
	6) : ;;
	7) : ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

inherit multilib-build

# @ECLASS-VARIABLE: RUST_TOOLCHAIN_BASEURL
# @DESCRIPTION:
# This variable specifies the base URL used by the
# rust_arch_uri and rust_all_arch_uris functions when
# generating the URI output list.
: ${RUST_TOOLCHAIN_BASEURL:=https://static.rust-lang.org/dist/}

# @FUNCTION: rust_abi
# @USAGE: [CHOST-value]
# @DESCRIPTION:
# Outputs the Rust ABI name from a CHOST value, uses CHOST in the
# environment if none is specified.

rust_abi() {
  local CTARGET=${1:-${CHOST}}
  case ${CTARGET%%*-} in
    aarch64*)     echo aarch64-unknown-linux-gnu;;
    mips64*)      echo mips64-unknown-linux-gnuabi64;;
    powerpc64le*) echo powerpc64le-unknown-linux-gnu;;
    powerpc64*)   echo powerpc64-unknown-linux-gnu;;
    x86_64*)      echo x86_64-unknown-linux-gnu;;
    armv6j*s*)    echo arm-unknown-linux-gnueabi;;
    armv6j*h*)    echo arm-unknown-linux-gnueabihf;;
    armv7a*h*)    echo armv7-unknown-linux-gnueabihf;;
    i?86*)        echo i686-unknown-linux-gnu;;
    mipsel*)      echo mipsel-unknown-linux-gnu;;
    mips*)        echo mips-unknown-linux-gnu;;
    powerpc*)     echo powerpc-unknown-linux-gnu;;
    s390x*)       echo s390x-unknown-linux-gnu;;
    *)            echo ${CTARGET};;
  esac
}

# @FUNCTION: rust_all_abis
# @DESCRIPTION:
# Outputs a list of all the enabled Rust ABIs
rust_all_abis() {
  if use multilib; then
    local abi
    local ALL_ABIS=()
    for abi in $(multilib_get_enabled_abis); do
      ALL_ABIS+=( $(rust_abi $(get_abi_CHOST ${abi})) )
    done
    local abi_list
    IFS=, eval 'abi_list=${ALL_ABIS[*]}'
    echo ${abi_list}
  else
    rust_abi
  fi
}

# @FUNCTION: rust_arch_uri
# @USAGE: <rust-ABI> <base-uri> [alt-distfile-basename]
# @DESCRIPTION:
# Output the URI for use in SRC_URI, combining $RUST_TOOLCHAIN_BASEURL
# and the URI suffix provided in ARG2 with the rust ABI in ARG1, and
# optionally renaming to the distfile basename specified in ARG3.
#
# @EXAMPLE:
# SRC_URI="amd64? (
#    $(rust_arch_uri x86_64-unknown-linux-gnu rustc-${STAGE0_VERSION})
# )"
#
rust_arch_uri() {
  if [ -n "$3" ]; then
    echo "${RUST_TOOLCHAIN_BASEURL}${2}-${1}.tar.xz -> ${3}-${1}.tar.xz"
  else
    echo "${RUST_TOOLCHAIN_BASEURL}${2}-${1}.tar.xz"
  fi
}

# @FUNCTION: rust_all_arch_uris
# @USAGE <base-uri> [alt-distfile-basename]
# @DESCRIPTION:
# Outputs the URIs for SRC_URI to help fetch dependencies, using a base URI
# provided as an argument.  Optionally allows for distfile renaming via a specified
# basename.
#
# @EXAMPLE:
# SRC_URI="$(rust_all_arch_uris rustc-${STAGE0_VERSION})"
#
rust_all_arch_uris()
{
  local uris=""
  uris+="amd64? ( $(rust_arch_uri x86_64-unknown-linux-gnu       "$@") ) "
  uris+="arm?   ( $(rust_arch_uri arm-unknown-linux-gnueabi      "$@")
                  $(rust_arch_uri arm-unknown-linux-gnueabihf    "$@")
                  $(rust_arch_uri armv7-unknown-linux-gnueabihf  "$@") ) "
  uris+="arm64? ( $(rust_arch_uri aarch64-unknown-linux-gnu      "$@") ) "
  uris+="mips?  ( $(rust_arch_uri mips-unknown-linux-gnu         "$@")
                  $(rust_arch_uri mipsel-unknown-linux-gnu       "$@")
                  $(rust_arch_uri mips64-unknown-linux-gnuabi64  "$@") ) "
  uris+="ppc?   ( $(rust_arch_uri powerpc-unknown-linux-gnu      "$@") ) "
  uris+="ppc64? ( $(rust_arch_uri powerpc64-unknown-linux-gnu    "$@")
                  $(rust_arch_uri powerpc64le-unknown-linux-gnu  "$@") ) "
  uris+="s390?  ( $(rust_arch_uri s390x-unknown-linux-gnu        "$@") ) "
  uris+="x86?   ( $(rust_arch_uri i686-unknown-linux-gnu         "$@") ) "
  echo "${uris}"
}
