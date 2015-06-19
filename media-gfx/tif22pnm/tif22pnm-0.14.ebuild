# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tif22pnm/tif22pnm-0.14.ebuild,v 1.1 2012/03/02 17:47:54 ssuominen Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="tif22pnm and png22pnm command-line converters"
HOMEPAGE="http://pts.szit.bme.hu/ http://code.google.com/p/sam2p/"
SRC_URI="http://sam2p.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libpng-1.2:0
	media-libs/tiff:0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_install() {
	dobin png22pnm tif22pnm
	dodoc README
}
