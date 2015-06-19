# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fracplanet/fracplanet-0.4.0.ebuild,v 1.3 2013/03/02 23:48:11 hwoarang Exp $

EAPI=4
inherit qt4-r2

DESCRIPTION="Fractal planet and terrain generator"
HOMEPAGE="http://sourceforge.net/projects/fracplanet/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/boost
	virtual/glu
	virtual/opengl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4"
DEPEND="${RDEPEND}
	dev-libs/libxslt"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}/${P}-gold.patch" )

src_compile() {
	xsltproc -stringparam version ${PV} -html htm_to_qml.xsl fracplanet.htm \
		| sed 's/"/\\"/g' | sed 's/^/"/g' | sed 's/$/\\n"/g'> usage_text.h
	qt4-r2_src_compile
}

src_install() {
	dobin ${PN}
	doman man/man1/${PN}.1
	dodoc BUGS NEWS README THANKS TODO
	dohtml *.{css,htm}
}
