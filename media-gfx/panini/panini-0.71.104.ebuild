# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-r2 eutils

MY_P="${P/p/P}-src"
DESCRIPTION="OpenGL-based panoramic image viewer"
HOMEPAGE="http://sourceforge.net/projects/pvqt/"
SRC_URI="mirror://sourceforge/pvqt/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtopengl:4
	virtual/glu
	sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-glu.patch
}

src_install() {
	newbin Panini panini
	dodoc panini-usage.txt panini-0.71-release.txt
	domenu "${FILESDIR}"/${PN}.desktop
	newicon ui/panini-icon-blue.jpg ${PN}.jpg
}
