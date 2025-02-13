# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rust-toolchain.eclass
# @MAINTAINER:
# Rust Project <rust@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: helps map gentoo arches to rust ABIs
# @DESCRIPTION:
# This eclass contains helper functions, to aid in proper rust-ABI handling for
# various gentoo arches.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: RUST_TOOLCHAIN_BASEURL
# @DESCRIPTION:
# This variable specifies the base URL used by the
# rust_arch_uri and rust_all_arch_uris functions when
# generating the URI output list.
: "${RUST_TOOLCHAIN_BASEURL:=https://static.rust-lang.org/dist/}"

# @FUNCTION: rust_abi
# @USAGE: [CHOST-value]
# @DESCRIPTION:
# Outputs the Rust ABI name from a CHOST value, uses CHOST in the
# environment if none is specified.

rust_abi() {
	local CTARGET=${1:-${CHOST}}
	case ${CTARGET%%*-} in
		aarch64*gnu)      echo aarch64-unknown-linux-gnu;;
		aarch64*musl)     echo aarch64-unknown-linux-musl;;
		armv6j*h*)        echo arm-unknown-linux-gnueabihf;;
		armv6j*s*)        echo arm-unknown-linux-gnueabi;;
		armv7a*h*)        echo armv7-unknown-linux-gnueabihf;;
		i?86*)            echo i686-unknown-linux-gnu;;
		loongarch64*)     echo loongarch64-unknown-linux-gnu;;
		mips64el*)        echo mips64el-unknown-linux-gnuabi64;;
		mips64*)          echo mips64-unknown-linux-gnuabi64;;
		mipsel*)          echo mipsel-unknown-linux-gnu;;
		mips*)            echo mips-unknown-linux-gnu;;
		powerpc64le*gnu)  echo powerpc64le-unknown-linux-gnu;;
		powerpc64le*musl) echo powerpc64le-unknown-linux-musl;;
		powerpc64*gnu)    echo powerpc64-unknown-linux-gnu;;
		powerpc64*musl)   echo powerpc64-unknown-linux-musl;;
		powerpc*gnu)      echo powerpc-unknown-linux-gnu;;
		powerpc*musl)     echo powerpc-unknown-linux-musl;;
		riscv64*gnu)      echo riscv64gc-unknown-linux-gnu;;
		riscv64*musl)     echo riscv64gc-unknown-linux-musl;;
		s390x*)           echo s390x-unknown-linux-gnu;;
		sparc64*gnu)      echo sparc64-unknown-linux-gnu;;
		x86_64*gnu)       echo x86_64-unknown-linux-gnu;;
		x86_64*musl)      echo x86_64-unknown-linux-musl;;
		*)                echo ${CTARGET};;
  esac
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
#	 $(rust_arch_uri x86_64-unknown-linux-gnu rustc-${STAGE0_VERSION})
# )"
#
rust_arch_uri() {
	if [ -n "$3" ]; then
		echo "${RUST_TOOLCHAIN_BASEURL}${2}-${1}.tar.xz -> ${3}-${1}.tar.xz"
		echo "verify-sig? ( ${RUST_TOOLCHAIN_BASEURL}${2}-${1}.tar.xz.asc -> ${3}-${1}.tar.xz.asc )"
	else
		echo "${RUST_TOOLCHAIN_BASEURL}${2}-${1}.tar.xz"
		echo "verify-sig? ( ${RUST_TOOLCHAIN_BASEURL}${2}-${1}.tar.xz.asc )"
	fi
}

# @FUNCTION: rust_all_arch_uris
# @USAGE: [alt-distfile-basename] [rust_arch_uri-rename-param]
# @DESCRIPTION:
# Outputs the URIs for SRC_URI to help fetch dependencies, using a base URI
# provided as an argument. Optionally allows for distfile renaming via a specified
# basename.
#
# @EXAMPLE:
# SRC_URI="$(rust_all_arch_uris rustc-${STAGE0_VERSION})"
#
rust_all_arch_uris()
{
	local alt_basename="$1"
	local rename_param="$2"

	echo "
	abi_x86_32? ( elibc_glibc? ( $(rust_arch_uri i686-unknown-linux-gnu "${alt_basename}" "${rename_param}") ) )
	abi_x86_64? (
		elibc_glibc? ( $(rust_arch_uri x86_64-unknown-linux-gnu  "${alt_basename}" "${rename_param}") )
		elibc_musl?  ( $(rust_arch_uri x86_64-unknown-linux-musl "${alt_basename}" "${rename_param}") )
	)
	arm? ( elibc_glibc? (
		$(rust_arch_uri arm-unknown-linux-gnueabi     "${alt_basename}" "${rename_param}")
		$(rust_arch_uri arm-unknown-linux-gnueabihf   "${alt_basename}" "${rename_param}")
		$(rust_arch_uri armv7-unknown-linux-gnueabihf "${alt_basename}" "${rename_param}")
	) )
	arm64? (
		elibc_glibc? ( $(rust_arch_uri aarch64-unknown-linux-gnu  "${alt_basename}" "${rename_param}") )
		elibc_musl?  ( $(rust_arch_uri aarch64-unknown-linux-musl "${alt_basename}" "${rename_param}") )
	)
	ppc? ( elibc_glibc? ( $(rust_arch_uri powerpc-unknown-linux-gnu "${alt_basename}" "${rename_param}") ) )
	ppc64? (
		big-endian?  ( elibc_glibc? ( $(rust_arch_uri powerpc64-unknown-linux-gnu   "${alt_basename}" "${rename_param}") ) )
		!big-endian? ( elibc_glibc? ( $(rust_arch_uri powerpc64le-unknown-linux-gnu "${alt_basename}" "${rename_param}") ) )
	)
	riscv? ( elibc_glibc? ( $(rust_arch_uri riscv64gc-unknown-linux-gnu "${alt_basename}" "${rename_param}") ) )
	s390?  ( elibc_glibc? ( $(rust_arch_uri s390x-unknown-linux-gnu     "${alt_basename}" "${rename_param}") ) )
	loong? ( elibc_glibc? ( $(rust_arch_uri loongarch64-unknown-linux-gnu "${alt_basename}" "${rename_param}") ) )
	"
}
