# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

MY_PV=${PV/./_}

DESCRIPTION="A series of tools for the PNG image format"
HOMEPAGE="http://www.stillhq.com/pngtools/"
SRC_URI="http://www.stillhq.com/pngtools/source/pngtools_${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=media-libs/libpng-1.4:0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3-implicit-declarations.patch
	epatch "${FILESDIR}"/${P}-libpng14.patch
	epatch "${FILESDIR}"/${P}-libpng15-fixes.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ABOUT AUTHORS ChangeLog NEWS README chunks.txt
	insinto /usr/share/doc/${PF}/examples
	doins *.png
}
