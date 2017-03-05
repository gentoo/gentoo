# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qmake-utils

DESCRIPTION="Fractal planet and terrain generator"
HOMEPAGE="https://sourceforge.net/projects/fracplanet/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	virtual/glu
	virtual/opengl
"
DEPEND="${RDEPEND}
	dev-libs/libxslt"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}/${P}-gold.patch"
	"${FILESDIR}/${P}-gcc6.patch"
)

HTML_DOCS=( fracplanet.{htm,css} )

src_configure() {
	eqmake4 fracplanet.pro
}

src_compile() {
	xsltproc -stringparam version ${PV} -html htm_to_qml.xsl fracplanet.htm \
		| sed 's/"/\\"/g' | sed 's/^/"/g' | sed 's/$/\\n"/g'> usage_text.h || die
	default
}

src_install() {
	dobin ${PN}
	doman man/man1/${PN}.1
	einstalldocs
}
