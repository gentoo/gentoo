# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_P="gperftools-${PV}"

inherit toolchain-funcs flag-o-matic autotools vcs-snapshot multilib-minimal

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="https://github.com/gperftools/gperftools"
SRC_URI="https://github.com/gperftools/gperftools/archive/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0/4"
# contains ASM code, with support for
# freebsd x86/amd64
# linux amd64/arm/arm64/ppc/ppc64/riscv/x86
# OSX ppc/amd64
# AIX ppc/ppc64
KEYWORDS="-* ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

IUSE="largepages largepages64k +debug minimal optimisememory test static-libs"

RESTRICT="!test? ( test )"

# TODO: remove the riscv special case once either libunwind has begun supporting this arch
# or this package allows using llvm-libunwind for other arches
DEPEND="!ppc64? (
	riscv? ( sys-libs/llvm-libunwind )
	!riscv? ( sys-libs/libunwind )
)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# set up the make options in here so that we can actually make use
	# of them on both compile and install.

	# Avoid building the unit testing if we're not going to execute
	# tests; this trick here allows us to ignore the tests without
	# touching the build system (and thus without rebuilding
	# autotools). Keep commented as long as it's restricted.
	use test || \
		MAKEOPTS+=" noinst_PROGRAMS= "
}

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	use largepages && append-cppflags -DTCMALLOC_LARGE_PAGES
	use largepages64k && append-cppflags -DTCMALLOC_LARGE_PAGES64K
	use optimisememory && append-cppflags -DTCMALLOC_SMALL_BUT_SLOW
	append-flags -fno-strict-aliasing -fno-omit-frame-pointer

	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable debug debugalloc) \
		$(if [[ ${ABI} == x32 ]]; then printf "--enable-minimal\n" else use_enable minimal; fi)
}

src_test() {
	case "${LD_PRELOAD}" in
		*libsandbox*)
			ewarn "Unable to run tests when sandbox is enabled."
			ewarn "See https://bugs.gentoo.org/290249"
			return 0
			;;
	esac

	multilib-minimal_src_test
}

src_install() {
	if ! use minimal && has x32 ${MULTILIB_ABIS}; then
		MULTILIB_WRAPPED_HEADERS=(
			/usr/include/gperftools/heap-checker.h
			/usr/include/gperftools/heap-profiler.h
			/usr/include/gperftools/stacktrace.h
			/usr/include/gperftools/profiler.h
		)
	fi

	multilib-minimal_src_install
}

multilib_src_install_all() {
	einstalldocs
	use static-libs || find "${D}" -name '*.la' -delete || die
}
