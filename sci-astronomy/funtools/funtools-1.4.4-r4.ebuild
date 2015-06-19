# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/funtools/funtools-1.4.4-r4.ebuild,v 1.1 2014/03/04 16:48:24 bicatali Exp $

EAPI=5
inherit eutils toolchain-funcs multilib autotools

DESCRIPTION="FITS library and utlities for astronomical images"
HOMEPAGE="http://www.cfa.harvard.edu/~john/funtools/"
SRC_URI="http://cfa-www.harvard.edu/~john/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="
	sys-libs/zlib
	sci-astronomy/wcstools
	sci-visualization/gnuplot"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ds9-fixes.patch \
		"${FILESDIR}"/${P}-fix-autoheader.patch \
		"${FILESDIR}"/${P}-fix-includes.patch \
		"${FILESDIR}"/${P}-fix-hardening.patch \
		"${FILESDIR}"/${P}-fix-crashes.patch \
		"${FILESDIR}"/${P}-makefiles.patch
	sed -i -e "s:/usr:${EPREFIX}/usr:g" filter/Makefile.in || die
	sed -i \
		-e "s:\${LINK}:\${LINK} ${LDFLAGS}:" \
		mklib || die "sed for ldflags failed"
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--enable-dl \
		--enable-mainlib \
		--with-wcslib="$($(tc-getPKG_CONFIG) --libs wcstools)" \
		--with-zlib="$($(tc-getPKG_CONFIG) --libs zlib)" \
		--with-tcl=-ltcl
}

src_compile() {
	emake WCS_INC="$($(tc-getPKG_CONFIG) --cflags wcstools)"
	emake shtclfun
}

src_install () {
	default
	dosym libtclfun.so.1 /usr/$(get_libdir)/libtclfun.so
	# install missing includes
	insinto /usr/include/funtools/fitsy
	doins fitsy/*.h
	use static-libs || rm "${ED}"/usr/$(get_libdir)/lib*.a
	use doc && cd doc && dodoc *.pdf && dohtml *html *c
}
