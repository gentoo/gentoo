# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-env.eclass
# @MAINTAINER:
# Flatcar Linux Maintainers <infra@flatcar-linux.org>
# @AUTHOR:
# Flatcar Linux Maintainers <infra@flatcar-linux.org>
# @BLURB: Helper eclass for setting the Go compile environment. Required for cross-compiling.
# @DESCRIPTION:
# This eclass includes helper functions for setting the compile environment for Go ebuilds.
# Intended to be called by other Go eclasses in an early build stage, e.g. src_unpack.

if [[ -z ${_GO_ENV_ECLASS} ]]; then
_GO_ENV_ECLASS=1

inherit toolchain-funcs

# @FUNCTION: go-env_set_compile_environment
# @DESCRIPTION:
# Set up basic compile environment: CC, CXX, and GOARCH.
# Also carry over CFLAGS, LDFLAGS and friends.
# Required for cross-compiling with crossdev.
# If not set, host defaults will be used and the resulting binaries are host arch.
# (e.g. "emerge-aarch64-cross-linux-gnu foo" run on x86_64 will emerge "foo" for x86_64
#  instead of aarch64)
go-env_set_compile_environment() {
	tc-export CC CXX

	export GOARCH="$(go-env_goarch)"
	export CGO_CFLAGS="${CGO_CFLAGS:-$CFLAGS}"
	export CGO_CPPFLAGS="${CGO_CPPFLAGS:-$CPPFLAGS}"
	export CGO_CXXFLAGS="${CGO_CXXFLAGS:-$CXXFLAGS}"
	export CGO_LDFLAGS="${CGO_LDFLAGS:-$LDFLAGS}"
}

# @FUNCTION: go-env_goarch
# @USAGE: [toolchain prefix]
# @DESCRIPTION:
# Returns the appropriate GOARCH setting for the target architecture.
go-env_goarch() {
	# By chance most portage arch names match Go
	local tc_arch=$(tc-arch $@)
	case "${tc_arch}" in
		x86)	echo 386;;
		x64-*)	echo amd64;;
		loong)	echo loong64;;
		mips) if use abi_mips_o32; then
				[[ $(tc-endian $@) = big ]] && echo mips || echo mipsle
			elif use abi_mips_n64; then
				[[ $(tc-endian $@) = big ]] && echo mips64 || echo mips64le
			fi ;;
		ppc64) [[ $(tc-endian $@) = big ]] && echo ppc64 || echo ppc64le ;;
		riscv) echo riscv64 ;;
		s390) echo s390x ;;
		*)		echo "${tc_arch}";;
	esac
}

fi
