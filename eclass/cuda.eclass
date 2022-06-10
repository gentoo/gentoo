# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

case "${EAPI:-0}" in
	[0-6])
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	7|8)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

# @ECLASS: cuda.eclass
# @MAINTAINER:
# Gentoo Science Project <sci@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Common functions for cuda packages
# @DESCRIPTION:
# This eclass contains functions to be used with cuda package. Currently it is
# setting and/or sanitizing ``NVCCFLAGS``, the compiler flags for ``nvcc``.
# This is automatically done and exported in ``src_prepare()`` or manually by
# calling ``cuda_sanatize``.
# @EXAMPLE:
# @CODE
# inherit cuda
# @CODE

if [[ -z ${_CUDA_ECLASS} ]]; then

inherit flag-o-matic toolchain-funcs
[[ ${EAPI} == [56] ]] && inherit eapi7-ver

# @ECLASS_VARIABLE: NVCCFLAGS
# @DESCRIPTION:
# ``nvcc`` compiler flags (see ``nvcc --help``), which should be used like
# ``CFLAGS`` for C compiler
: ${NVCCFLAGS:=-O2}

# @ECLASS_VARIABLE: CUDA_VERBOSE
# @DESCRIPTION:
# Being verbose during compilation to see underlying commands
: ${CUDA_VERBOSE:=true}

# @FUNCTION: cuda_gccdir
# @USAGE: [-f]
# @RETURN: gcc bindir compatible with current cuda, optionally (``-f``) prefixed with ``--compiler-bindir``
# @DESCRIPTION:
# Helper for determination of the latest gcc bindir supported by
# then current nvidia cuda toolkit.
#
# Example:
# @CODE
# cuda_gccdir -f
# -> --compiler-bindir "/usr/x86_64-pc-linux-gnu/gcc-bin/4.6.3"
# @CODE
cuda_gccdir() {
	debug-print-function ${FUNCNAME} "$@"

	local dirs gcc_bindir ver vers="" flag

	# Currently we only support the gnu compiler suite
	if ! tc-is-gcc ; then
		ewarn "Currently we only support the gnu compiler suite"
		return 2
	fi

	while [[ "$1" ]]; do
		case $1 in
			-f)
				flag="--compiler-bindir "
				;;
			*)
				;;
		esac
		shift
	done

	if ! vers="$(cuda-config -s)"; then
		eerror "Could not execute cuda-config"
		eerror "Make sure >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 is installed"
		die "cuda-config not found"
	fi
	if [[ -z ${vers} ]]; then
		die "Could not determine supported gcc versions from cuda-config"
	fi

	# Try the current gcc version first
	ver=$(gcc-version)
	if [[ -n "${ver}" ]] && [[ ${vers} =~ ${ver} ]]; then
		dirs=( ${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/${ver}*/ )
		gcc_bindir="${dirs[${#dirs[@]}-1]}"
	fi

	if [[ -z ${gcc_bindir} ]]; then
		ver=$(best_version "sys-devel/gcc")
		ver=$(ver_cut 1-2 "${ver##*sys-devel/gcc-}")

		if [[ -n "${ver}" ]] && [[ ${vers} =~ ${ver} ]]; then
			dirs=( ${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/${ver}*/ )
			gcc_bindir="${dirs[${#dirs[@]}-1]}"
		fi
	fi

	for ver in ${vers}; do
		if has_version "=sys-devel/gcc-${ver}*"; then
			dirs=( ${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/${ver}*/ )
			gcc_bindir="${dirs[${#dirs[@]}-1]}"
		fi
	done

	if [[ -n ${gcc_bindir} ]]; then
		if [[ -n ${flag} ]]; then
			echo "${flag}\"${gcc_bindir%/}\""
		else
			echo "${gcc_bindir%/}"
		fi
		return 0
	else
		eerror "Only gcc version(s) ${vers} are supported,"
		eerror "of which none is installed"
		die "Only gcc version(s) ${vers} are supported"
		return 1
	fi
}

# @FUNCTION: cuda_sanitize
# @DESCRIPTION:
# Correct ``NVCCFLAGS`` by adding the necessary reference to gcc bindir and
# passing ``CXXFLAGS`` to underlying compiler without disturbing ``nvcc``.
cuda_sanitize() {
	debug-print-function ${FUNCNAME} "$@"

	local rawldflags=$(raw-ldflags)
	# Be verbose if wanted
	[[ "${CUDA_VERBOSE}" == true ]] && NVCCFLAGS+=" -v"

	# Tell nvcc where to find a compatible compiler
	NVCCFLAGS+=" $(cuda_gccdir -f)"

	# Tell nvcc which flags should be used for underlying C compiler
	NVCCFLAGS+=" --compiler-options \"${CXXFLAGS}\" --linker-options \"${rawldflags// /,}\""

	debug-print "Using ${NVCCFLAGS} for cuda"
	export NVCCFLAGS
}

# @FUNCTION: cuda_add_sandbox
# @USAGE: [-w]
# @DESCRIPTION:
# Add nvidia dev nodes to the sandbox predict list.
# With ``-w``, add to the sandbox write list.
cuda_add_sandbox() {
	debug-print-function ${FUNCNAME} "$@"

	local i
	for i in /dev/nvidia*; do
		if [[ $1 == '-w' ]]; then
			addwrite $i
		else
			addpredict $i
		fi
	done
}

# @FUNCTION: cuda_toolkit_version
# @DESCRIPTION:
# echo the installed version of ``dev-util/nvidia-cuda-toolkit``
cuda_toolkit_version() {
	debug-print-function ${FUNCNAME} "$@"

	local v
	v="$(best_version dev-util/nvidia-cuda-toolkit)"
	v="${v##*cuda-toolkit-}"
	ver_cut 1-2 "${v}"
}

# @FUNCTION: cuda_cudnn_version
# @DESCRIPTION:
# echo the installed version of ``dev-libs/cudnn``
cuda_cudnn_version() {
	debug-print-function ${FUNCNAME} "$@"

	local v
	v="$(best_version dev-libs/cudnn)"
	v="${v##*cudnn-}"
	ver_cut 1-2 "${v}"
}

# @FUNCTION: cuda_src_prepare
# @DESCRIPTION:
# Sanitise and export ``NVCCFLAGS`` by default
cuda_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	cuda_sanitize
}

EXPORT_FUNCTIONS src_prepare

_CUDA_ECLASS=1
fi
