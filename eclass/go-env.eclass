# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-env.eclass
# @MAINTAINER:
# Flatcar Linux Maintainers <infra@flatcar-linux.org>
# @AUTHOR:
# Flatcar Linux Maintainers <infra@flatcar-linux.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Helper eclass for setting up the Go build environment.
# @DESCRIPTION:
# This eclass includes helper functions for setting up the build environment for
# Go ebuilds. Intended to be called by other Go eclasses in an early build
# stage, e.g. src_unpack.

# @ECLASS_VARIABLE: GOMAXPROCS
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The maximum number of processes for the Go runtime to run in parallel. See
# https://pkg.go.dev/runtime#GOMAXPROCS. If unset, this defaults to the
# configured number of Make jobs. Unfortunately, Go does not currently support
# the GNU Make jobserver, so this may not play nicely alongside other build
# processes. However, Go code is often built without a supporting build system
# or without other non-Go code, so this should be sufficient in most cases.

# @ECLASS_VARIABLE: GOAMD64
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optimisation setting for amd64 when building for CHOST. See
# https://golang.org/wiki/MinimumRequirements#amd64.

# @ECLASS_VARIABLE: GOARM64
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optimisation setting for arm64 when building for CHOST. See
# https://pkg.go.dev/cmd/go/internal/help#pkg-variables.

# @ECLASS_VARIABLE: GOPPC64
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optimisation setting for ppc64 when building for CHOST. See
# https://pkg.go.dev/cmd/go/internal/help#pkg-variables.

# @ECLASS_VARIABLE: GORISCV64
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optimisation setting for riscv when building for CHOST. See
# https://pkg.go.dev/cmd/go/internal/help#pkg-variables.

# @ECLASS_VARIABLE: BUILD_GOAMD64
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optimisation setting for amd64 when building for CBUILD.

# @ECLASS_VARIABLE: BUILD_GOARM64
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optimisation setting for arm64 when building for CBUILD.

# @ECLASS_VARIABLE: BUILD_GOPPC64
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optimisation setting for ppc64 when building for CBUILD.

# @ECLASS_VARIABLE: BUILD_GORISCV64
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optimisation setting for riscv when building for CBUILD.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GO_ENV_ECLASS} ]]; then
_GO_ENV_ECLASS=1

inherit flag-o-matic multiprocessing sysroot toolchain-funcs

# @FUNCTION: go-env_set_compile_environment
# @DESCRIPTION:
# Sets up the environment to build Go code for CHOST. This includes variables
# required for cross-compiling, cgo-related variables, and architecture-specific
# variables. GO386, GOARM, GOMIPS, and GOMIPS64 are set based on the tuple.
# Variables for other architectures need to be set manually by users. This
# function must be called (implicitly or otherwise) before building any Go code
# whether cross-compiling or not. Make any build flag changes (e.g. CFLAGS)
# before calling this function.
go-env_set_compile_environment() {
	tc-export AR CC CXX FC PKG_CONFIG

	# Go uses all cores by default. Use the configured number of Make jobs, but
	# respect the user value, as described above.
	: "${GOMAXPROCS=$(get_makeopts_jobs)}"
	export GOMAXPROCS

	# The following GOFLAGS should be used for all builds.
	# -x prints commands as they are executed
	# -v prints the names of packages as they are compiled
	# -modcacherw makes the build cache read/write
	# -buildvcs=false omits version control information
	# -buildmode=pie builds position independent executables
	export \
		GOFLAGS="-x -v -modcacherw -buildvcs=false" \
		GOARCH=$(go-env_goarch) \
		GOOS=$(go-env_goos)

	case ${GOARCH} in
		386|amd64|arm*|ppc64le|s390*) GOFLAGS+=" -buildmode=pie" ;;
	esac

	case ${GOARCH} in
		386) export GO386=$(go-env_go386) ;;
		arm|armbe) export GOARM=$(go-env_goarm) ;;
		mips64*) export GOMIPS64=$(go-env_gomips) ;;
		mips*) export GOMIPS=$(go-env_gomips) ;;
	esac

	# Don't modify the non-Go variables outside this function.
	local -I $(all-flag-vars)

	if tc-is-gcc ; then
		# XXX: Hack for checking ICE (bug #912152, gcc PR113204)
		# For either USE=debug or an unreleased compiler, non-default
		# checking will trigger.
		$(tc-getCC) -v 2>&1 | grep -Eqe "--enable-checking=\S*\byes\b" && filter-lto

		# bug #929219
		replace-flags -g3 -g
		replace-flags -ggdb3 -ggdb
	fi

	export \
		CGO_CFLAGS=${CFLAGS} \
		CGO_CPPFLAGS=${CPPFLAGS} \
		CGO_CXXFLAGS=${CXXFLAGS} \
		CGO_LDFLAGS=${LDFLAGS}

	# go run will build binaries for the target system and try to execute them.
	# This will fail when cross-compiling unless you provide a wrapper.
	local script
	if script=$(sysroot_make_run_prefixed); then
		GOFLAGS+=" -exec=${script}" "${@}"
	fi
}

# @FUNCTION: go-env_run
# @DESCRIPTION:
# Runs the given command under a localised environment configured by
# go-env_set_compile_environment. It is not usually necessary to call this, but
# it is useful when combined with tc-env_build.
go-env_run() {
	local -I AR CC CXX FC PKG_CONFIG \
		GO{FLAGS,MAXPROCS,ARCH,OS,386,ARM,MIPS,MIPS64} \
		CGO_{CFLAGS,CPPFLAGS,CXXFLAGS,LDFLAGS}

	go-env_set_compile_environment
	"${@}"
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
		*-gnu) echo hurd ;;
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
# @USAGE: [tuple]
# @DESCRIPTION:
# Returns the appropriate GOARM setting for given target or CHOST.
go-env_goarm() {
	local CTARGET=${1:-${CHOST}}

	case ${CTARGET} in
		armv5*)	echo -n 5 ;;
		armv6*)	echo -n 6 ;;
		armv7*)	echo -n 7 ;;
		*) die "unknown GOARM for ${CTARGET}" ;;
	esac

	if [[ $(tc-is-softfloat) == no ]]; then
		echo ,hardfloat
	else
		echo ,softfloat
	fi
}

# @FUNCTION: go-env_gomips
# @USAGE: [tuple]
# @DESCRIPTION:
# Returns the appropriate GOMIPS or GOMIPS64 setting for given target or CHOST.
go-env_gomips() {
	local CTARGET=${1:-${CHOST}}

	if [[ $(tc-is-softfloat) == no ]]; then
		echo hardfloat
	else
		echo softfloat
	fi
}

fi
