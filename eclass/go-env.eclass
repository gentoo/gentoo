# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-env.eclass
# @MAINTAINER:
# Flatcar Linux Maintainers <infra@flatcar-linux.org>
# @AUTHOR:
# Flatcar Linux Maintainers <infra@flatcar-linux.org>
# @BLURB: Helper eclass for setting the Go compile environment. Required for cross-compiling.
# @DESCRIPTION:
# This eclass includes a helper function for setting the compile environment for Go ebuilds.
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
	local arch="$(tc-arch)"
	case "${arch}" in
		x86)	GOARCH="386" ;;
		x64-*)	GOARCH="amd64" ;;
		ppc64)	if [[ "$(tc-endian)" == "big" ]] ; then
					GOARCH="ppc64"
				else
					GOARCH="ppc64le"
				fi ;;
			*)	GOARCH="${arch}" ;;
	esac

	tc-export CC CXX
	export GOARCH
	export CGO_CFLAGS="${CGO_CFLAGS:-$CFLAGS}"
	export CGO_CPPFLAGS="${CGO_CPPFLAGS:-$CPPFLAGS}"
	export CGO_CXXFLAGS="${CGO_CXXFLAGS:-$CXXFLAGS}"
	export CGO_LDFLAGS="${CGO_LDFLAGS:-$LDFLAGS}"
}

fi
