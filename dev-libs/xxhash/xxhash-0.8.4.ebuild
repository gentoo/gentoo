# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
HOMEPAGE="https://xxhash.com/"
SRC_URI="https://github.com/Cyan4973/xxHash/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/xxHash-${PV}

LICENSE="BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

src_prepare() {
	default

	multilib_copy_sources
}

src_configure() {
	# Needed for -Og to be buildable, otherwise fails a/ always_inline (bug #961093)
	# https://github.com/Cyan4973/xxHash?tab=readme-ov-file#binary-size-control
	is-flagq '-Og' && append-cppflags -DXXH_NO_INLINE_HINTS
	multilib-minimal_src_configure

	use static-libs && lto-guarantee-fat
}

myemake() {
	# need LIBDIR set during compile too for Darwin, bug #966267
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		MANDIR='$(man1dir)' \
		"${@}"
}

multilib_src_compile() {
	myemake
}

multilib_src_test() {
	# Injecting CPPFLAGS into CFLAGS is needed for test_sanity
	myemake CFLAGS="${CPPFLAGS} ${CFLAGS}" check
}

multilib_src_install() {
	myemake DESTDIR="${D}" install
	einstalldocs

	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/libxxhash.a || die
	else
		strip-lto-bytecode
	fi
}
