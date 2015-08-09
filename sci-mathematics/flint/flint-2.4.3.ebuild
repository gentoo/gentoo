# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gc ntl static-libs test"

RDEPEND="dev-libs/gmp
	dev-libs/mpfr
	gc? ( dev-libs/boehm-gc )
	ntl? ( dev-libs/ntl )"
DEPEND="${RDEPEND}
	doc? ( app-text/texlive-core )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.4.3-libdir.patch \
		"${FILESDIR}"/${PN}-2.4.3-whitespaces.patch \
		"${FILESDIR}"/${PN}-2.4.3-cflags-ldflags.patch
}

src_configure() {
	./configure \
		--prefix="${EPREFIX}/usr" \
		--with-gmp="${EPREFIX}/usr" \
		--with-mpfr="${EPREFIX}/usr" \
		$(usex ntl "--with-ntl=${EPREFIX}/usr" "") \
		$(use_enable static-libs static) \
		$(usex gc "--with-gc=${EPREFIX}/usr" "") \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		|| die
}

src_compile() {
	emake verbose

	if use doc ; then
		emake -C doc/latex
	fi
}

src_test() {
	emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
	einstalldocs
	use doc && dodoc doc/latex/flint-manual.pdf
}
