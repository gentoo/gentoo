# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-env.eclass
# @MAINTAINER:
# Flatcar Linux Maintainers <infra@flatcar-linux.org>
# @AUTHOR:
# Flatcar Linux Maintainers <infra@flatcar-linux.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Helper eclass for setting the Go compile environment. Required for cross-compiling.
# @DESCRIPTION:
# This eclass includes helper functions for setting the compile environment for Go ebuilds.
# Intended to be called by other Go eclasses in an early build stage, e.g. src_unpack.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GO_ENV_ECLASS} ]]; then
_GO_ENV_ECLASS=1

inherit flag-o-matic toolchain-funcs

# @FUNCTION: go-env_set_compile_environment
# @DESCRIPTION:
# Set up basic compile environment: CC, CXX, and GOARCH.
# Necessary platform-specific settings such as GOARM or GO386 are also set
# according to the Portage configuration when building for those architectures.
# Also carry over CFLAGS, LDFLAGS and friends.
# Required for cross-compiling with crossdev.
# If not set, host defaults will be used and the resulting binaries are host arch.
# (e.g. "emerge-aarch64-cross-linux-gnu foo" run on x86_64 will emerge "foo" for x86_64
#  instead of aarch64)
go-env_set_compile_environment() {
	tc-export CC CXX PKG_CONFIG

	export GOARCH="$(go-env_goarch)"
	use arm && export GOARM=$(go-env_goarm)
	use x86 && export GO386=$(go-env_go386)

	# XXX: Hack for checking ICE (bug #912152, gcc PR113204)
	has_version -b "sys-devel/gcc[debug]" && filter-lto

	# bug #929219
	if tc-is-gcc ; then
		replace-flags -g3 -g
		replace-flags -ggdb3 -ggdb
	fi

	export CGO_CFLAGS="${CGO_CFLAGS:-$CFLAGS}"
	export CGO_CPPFLAGS="${CGO_CPPFLAGS:-$CPPFLAGS}"
	export CGO_CXXFLAGS="${CGO_CXXFLAGS:-$CXXFLAGS}"
	export CGO_LDFLAGS="${CGO_LDFLAGS:-$LDFLAGS}"
}

# @FUNCTION: go-env_goos
# @USAGE: [toolchain prefix]
# @DESCRIPTION:
# Returns the appropriate GOOS setting for the target operating system.
go-env_goos() {
	local target=${1:-${CHOST}}
	case "${target}" in
		*-linux*) echo linux ;;
		*-darwin*) echo darwin ;;
		*-freebsd*) echo freebsd ;;
		*-netbsd*) echo netbsd ;;
		*-openbsd*) echo openbsd ;;
		*-solaris*) echo solaris ;;
		*-cygwin*|*-interix*|*-winnt*) echo windows ;;
		*) die "unknown GOOS for ${target}" ;;
	esac
}

# @FUNCTION: go-env_goarch
# @USAGE: [toolchain prefix]
# @DESCRIPTION:
# Returns the appropriate GOARCH setting for the target architecture.
go-env_goarch() {
	local target=${1:-${CHOST}}
	# Some Portage arch names match Go.
	local arch=$(tc-arch "${target}") cpu=${target%%-*}
	case "${arch}" in
		x86)	echo 386 ;;
		loong)	echo loong64 ;;
		*)		case "${cpu}" in
					aarch64*be) echo arm64be ;;
					arm64) echo arm64 ;;
					arm*b*) echo armbe ;;
					mips64*l*) echo mips64le ;;
					mips*l*) echo mipsle ;;
					powerpc64le*) echo ppc64le ;;
					arm64|s390x) echo "${cpu}" ;;
					mips64*|riscv64*|sparc64*) echo "${arch}64" ;;
					*) echo "${arch}" ;;
				esac ;;
	esac
}

# @FUNCTION: go-env_go386
# @DESCRIPTION:
# Returns the appropriate GO386 setting for the CFLAGS in use.
go-env_go386() {
	# Piggy-back off any existing CPU_FLAGS_X86 usage in the ebuild if
	# it's there.
	if in_iuse cpu_flags_x86_sse2 && use cpu_flags_x86_sse2 ; then
		echo 'sse2'
		return
	fi

	if tc-cpp-is-true "defined(__SSE2__)" ${CFLAGS} ${CXXFLAGS} ; then
		echo 'sse2'
		return
	fi

	# Go 1.16 dropped explicit support for 386 FP and relies on software
	# emulation instead in the absence of SSE2.
	echo 'softfloat'
}

# @FUNCTION: go-env_goarm
# @USAGE: [CHOST-value]
# @DESCRIPTION:
# Returns the appropriate GOARM setting for the CHOST given, or the default
# CHOST.
go-env_goarm() {
	case "${1:-${CHOST}}" in
		armv5*)	echo 5;;
		armv6*)	echo 6;;
		armv7*)	echo 7;;
		*)
			die "unknown GOARM for ${1:-${CHOST}}"
			;;
	esac
}

fi
