# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/exempi/exempi-2.2.0.ebuild,v 1.10 2013/08/03 07:33:20 ago Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="Exempi is a port of the Adobe XMP SDK to work on UNIX"
HOMEPAGE="http://libopenraw.freedesktop.org/wiki/Exempi"
SRC_URI="http://libopenraw.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="examples static-libs"

RDEPEND=">=dev-libs/expat-2
	virtual/libiconv
	sys-libs/zlib"
DEPEND="${RDEPEND}
	sys-devel/gettext"

RESTRICT="test" #295875

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1.1-iconv.patch
	cp /usr/share/gettext/config.rpath . || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-unittest
}

src_install() {
	default

	rm -f "${ED}"usr/lib*/lib*.la

	if use examples; then
		emake -C samples/source distclean
		rm -f samples/{,source,testfiles}/Makefile*
		insinto /usr/share/doc/${PF}/examples
		doins -r samples/*
	fi
}
