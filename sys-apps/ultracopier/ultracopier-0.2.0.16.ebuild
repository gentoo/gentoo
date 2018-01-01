# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop qmake-utils

DESCRIPTION="Advanced file copying tool"
HOMEPAGE="http://ultracopier.first-world.info/"
SRC_URI="http://files.first-world.info/${PN}/${PV}/${PN}-src-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e "s/\(DEBUG_ULTRACOPIER\) 0/\1 $(usex debug 100 0)/" src/var.h || die
}

src_configure() {
	eqmake4
}

src_install() {
	einstalldocs

	cd src || die
	rm -f lang/en* lang/*.ts || die
	rm -Rf styles/kde3 || die

	dobin ${PN}
	newicon other/${PN}-128x128.png ${PN}.png
	domenu other/${PN}.desktop

	insinto /usr/share/${PN}
	doins -r lang styles
}
