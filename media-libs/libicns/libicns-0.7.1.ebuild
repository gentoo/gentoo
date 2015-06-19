# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libicns/libicns-0.7.1.ebuild,v 1.3 2010/05/21 16:30:50 ssuominen Exp $

EAPI=2

DESCRIPTION="A library for manipulating MacOS X .icns icon format"
HOMEPAGE="http://sourceforge.net/projects/icns"
SRC_URI="mirror://sourceforge/icns/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-libs/libpng-1.2.43-r2:0
	media-libs/jasper"

src_prepare() {
	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:g' \
		icnsutils/png2icns.c || die
}

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog DEVNOTES README TODO
}
