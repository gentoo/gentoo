# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libspectre/libspectre-0.2.7.ebuild,v 1.6 2012/12/01 19:47:58 armin76 Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="A library for rendering Postscript documents"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/libspectre"
SRC_URI="http://libspectre.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug doc static-libs"

RDEPEND=">=app-text/ghostscript-gpl-8.62"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

# does not actually test anything, see bug 362557
RESTRICT="test"

DOCS="NEWS README TODO"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.2.0-interix.patch
	eautoreconf # need new libtool for interix
}

src_configure() {
	econf \
		$(use_enable debug asserts) \
		$(use_enable debug checks) \
		$(use_enable static-libs static) \
		--disable-test
}

src_compile() {
	emake
	if use doc; then
		doxygen || die
	fi
}

src_install() {
	default
	use doc && dohtml -r doc/html/*
	find "${D}" -name '*.la' -exec rm -f {} +
}
