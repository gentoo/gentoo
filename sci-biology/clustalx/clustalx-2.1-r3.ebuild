# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

DESCRIPTION="Graphical interface for the ClustalW multiple alignment program"
HOMEPAGE="https://www.ebi.ac.uk/Tools/msa/clustalw2/"
SRC_URI="
	http://www.clustal.org/download/current/${P}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}.png.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}
	>=sci-biology/clustalw-${PV}
"

PATCHES=( "${FILESDIR}/${P}"-qt5.patch ) # kindly borrowed from Debian

src_prepare() {
	default
	sed \
		-e "s|colprot.xml|${EPREFIX}/usr/share/${PN}/colprot.xml|" \
		-e "s|coldna.xml|${EPREFIX}/usr/share/${PN}/coldna.xml|" \
		-e "s|colprint.xml|${EPREFIX}/usr/share/${PN}/colprint.xml|" \
		-i ClustalQtParams.h || \
		die "Failed to patch shared files location."
	sed \
		-e "s|clustalx.hlp|${EPREFIX}/usr/share/${PN}/clustalx.hlp|" \
		-i HelpDisplayWidget.cpp || \
		die "Failed to patch help file location."
	rm -r usr || die
}

src_configure() {
	eqmake5
}

src_install() {
	dobin clustalx
	insinto /usr/share/${PN}
	doins colprot.xml coldna.xml colprint.xml clustalx.hlp
	make_desktop_entry ${PN} ClustalX
	doicon "${WORKDIR}"/${PN}.png
}
