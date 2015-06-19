# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gqview/gqview-2.1.5-r1.ebuild,v 1.6 2014/12/05 10:17:33 ago Exp $

EAPI=5
inherit eutils autotools

DESCRIPTION="A GTK-based image browser"
HOMEPAGE="http://gqview.sourceforge.net/"
SRC_URI="mirror://sourceforge/gqview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4:2
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-windows.patch" \
		"${FILESDIR}/${P}-glibc.patch"
	sed -i \
		-e '/^Encoding/d' \
		-e '/^Icon/s/\.png//' \
		-e '/^Categories/s/Application;//' \
		gqview.desktop || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf --without-lcms
}

src_install() {
	emake DESTDIR="${D}" install
	# leave README uncompressed because the program reads it
	dodoc AUTHORS ChangeLog TODO
	rm -f "${D}/usr/share/doc/${PF}/COPYING"
}
