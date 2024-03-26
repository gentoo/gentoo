# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="gperftools-${PV}"
inherit flag-o-matic autotools vcs-snapshot multilib-minimal

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

IUSE="pagesize-16k pagesize-32k pagesize-64k pagesize-128k pagesize-256k +debug llvm-libunwind minimal optimisememory test static-libs"
REQUIRED_USE="?? ( pagesize-16k pagesize-32k pagesize-64k pagesize-128k pagesize-256k )"

RESTRICT="!test? ( test )"

DEPEND="
	llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# Please keep this if possible on bumps, check Fedora if needs rebasing
	# Allows correct functionality on e.g. arm64, bug #818871
	"${FILESDIR}"/${PN}-2.9.1-disable-generic-dynamic-tls.patch
)

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
	use optimisememory && append-cppflags -DTCMALLOC_SMALL_BUT_SLOW
	use pagesize-16k && append-cppflags -DTCMALLOC_PAGE_SIZE_SHIFT=14
	use pagesize-32k && append-cppflags -DTCMALLOC_PAGE_SIZE_SHIFT=15
	use pagesize-64k && append-cppflags -DTCMALLOC_PAGE_SIZE_SHIFT=16
	use pagesize-128k && append-cppflags -DTCMALLOC_PAGE_SIZE_SHIFT=17
	use pagesize-256k && append-cppflags -DTCMALLOC_PAGE_SIZE_SHIFT=18
	append-flags -fno-strict-aliasing -fno-omit-frame-pointer

	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable debug debugalloc)
	)

	if [[ ${ABI} == x32 ]]; then
		myeconfargs+=( --enable-minimal )
	else
		myeconfargs+=( $(use_enable minimal) )
	fi

	if use arm64 || use s390; then
		# Use the same arches for disabling TLS (thread local storage)
		# as Fedora, but we might need to expand this list if we get
		# more odd segfaults in consumers like in bug #818871.
		myeconfargs+=( --disable-general-dynamic-tls )
	fi

	econf "${myeconfargs[@]}"
}

src_test() {
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

	use static-libs || find "${ED}" -name '*.la' -delete || die
}
