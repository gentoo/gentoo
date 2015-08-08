# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic toolchain-funcs versionator

# @ECLASS: cuda.eclass
# @MAINTAINER:
# Justin Lecher <jlec@gentoo.org>
# @BLURB: Common functions for cuda packages
# @DESCRIPTION:
# This eclass contains functions to be used with cuda package. Currently it is
# setting and/or sanitizing NVCCFLAGS, the compiler flags for nvcc. This is
# automatically done and exported in src_prepare() or manually by calling
# cuda_sanatize.
# @EXAMPLE:
# inherit cuda

# @ECLASS-VARIABLE: NVCCFLAGS
# @DESCRIPTION:
# nvcc compiler flags (see nvcc --help), which should be used like
# CFLAGS for c compiler
: ${NVCCFLAGS:=-O2}

# @ECLASS-VARIABLE: CUDA_VERBOSE
# @DESCRIPTION:
# Being verbose during compilation to see underlying commands
: ${CUDA_VERBOSE:=true}

# @FUNCTION: cuda_gccdir
# @USAGE: [-f]
# @RETURN: gcc bindir compatible with current cuda, optionally (-f) prefixed with "--compiler-bindir="
# @DESCRIPTION:
# Helper for determination of the latest gcc bindir supported by
# then current nvidia cuda toolkit.
#
# Example:
# @CODE
# cuda_gccdir -f
# -> --compiler-bindir="/usr/x86_64-pc-linux-gnu/gcc-bin/4.6.3"
# @CODE
cuda_gccdir() {
	local gcc_bindir ver args="" flag ret

	# Currently we only support the gnu compiler suite
	if [[ $(tc-getCXX) != *g++* ]]; then
		ewarn "Currently we only support the gnu compiler suite"
		return 2
	fi

	while [ "$1" ]; do
		case $1 in
			-f)
				flag="--compiler-bindir="
				;;
			*)
				;;
		esac
		shift
	done

	if ! args=$(cuda-config -s); then
		eerror "Could not execute cuda-config"
		eerror "Make sure >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 is installed"
		die "cuda-config not found"
	else
		args=$(version_sort ${args})
		if [[ -z ${args} ]]; then
			die "Could not determine supported gcc versions from cuda-config"
		fi
	fi

	for ver in ${args}; do
		has_version "=sys-devel/gcc-${ver}*" && \
		 gcc_bindir="$(ls -d ${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/${ver}* | tail -n 1)"
	done

	if [[ -n ${gcc_bindir} ]]; then
		if [[ -n ${flag} ]]; then
			ret="${flag}\"${gcc_bindir}\""
		else
			ret="${gcc_bindir}"
		fi
		echo ${ret}
		return 0
	else
		eerror "Only gcc version(s) ${args} are supported,"
		eerror "of which none is installed"
		die "Only gcc version(s) ${args} are supported"
		return 1
	fi
}

# @FUNCTION: cuda_sanitize
# @DESCRIPTION:
# Correct NVCCFLAGS by adding the necessary reference to gcc bindir and
# passing CXXFLAGS to underlying compiler without disturbing nvcc.
cuda_sanitize() {
	local rawldflags=$(raw-ldflags)
	# Be verbose if wanted
	[[ "${CUDA_VERBOSE}" == true ]] && NVCCFLAGS+=" -v"

	# Tell nvcc where to find a compatible compiler
	NVCCFLAGS+=" $(cuda_gccdir -f)"

	# Tell nvcc which flags should be used for underlying C compiler
	NVCCFLAGS+=" --compiler-options=\"${CXXFLAGS}\" --linker-options=\"${rawldflags// /,}\""

	debug-print "Using ${NVCCFLAGS} for cuda"
	export NVCCFLAGS
}

# @FUNCTION: cuda_pkg_setup
# @DESCRIPTION:
# Call cuda_src_prepare for EAPIs not supporting src_prepare
cuda_pkg_setup() {
	cuda_src_prepare
}

# @FUNCTION: cuda_src_prepare
# @DESCRIPTION:
# Sanitise and export NVCCFLAGS by default
cuda_src_prepare() {
	cuda_sanitize
}


case "${EAPI:-0}" in
	0|1)
		EXPORT_FUNCTIONS pkg_setup ;;
	2|3|4|5)
		EXPORT_FUNCTIONS src_prepare ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac
