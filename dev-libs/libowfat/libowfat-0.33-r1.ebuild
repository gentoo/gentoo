# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="reimplement libdjb - excellent libraries from Dan Bernstein"
SRC_URI="https://www.fefe.de/${PN}/${P}.tar.xz"
HOMEPAGE="https://www.fefe.de/libowfat/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa sparc x86"
IUSE="diet"

RDEPEND="diet? ( >=dev-libs/dietlibc-0.33_pre20090721 )"
DEPEND="${RDEPEND}"

pkg_setup() {
	# Required for mult/umult64.c to be usable
	append-flags -fomit-frame-pointer
}

src_compile() {
	# Primary use case is for code by the same author. Which then fails with
	# LTO errors.  It builds a static library only, anyway. Result: LTO can be
	# used if you don't upgrade the compiler. If you do, the compiler errors,
	# or if you are unlucky, ICEs. Just don't use LTO, there is no point...
	filter-lto

	# workaround for broken dependencies
	emake headers

	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		CFLAGS="-I. ${CFLAGS}" \
		DIET="${EPREFIX}/usr/bin/diet -Os" \
		prefix="${EPREFIX}/usr" \
		INCLUDEDIR="${EPREFIX}/usr/include" \
		$( use diet || echo 'DIET=' )
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		MAN3DIR="${EPREFIX}/usr/share/man/man3" \
		INCLUDEDIR="${EPREFIX}/usr/include" \
		install

	mv "${ED}"/usr/share/man/man3/{buffer.3,owfat-buffer.3} || die
}
