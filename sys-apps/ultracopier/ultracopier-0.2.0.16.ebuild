# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ultracopier/ultracopier-0.2.0.16.ebuild,v 1.2 2013/03/02 23:33:00 hwoarang Exp $

EAPI=2

inherit eutils qt4-r2

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
	local debugl=0
	use debug && debugl=100
	sed -i -e "s/\(DEBUG_ULTRACOPIER\) 0/\1 ${debugl}/" src/var.h || die
}

src_install() {
	dodoc CHANGELOG README || die

	cd src || die
	rm -f lang/en* lang/*.ts || die
	rm -Rf styles/kde3 || die

	dobin ${PN} || die
	newicon other/${PN}-128x128.png ${PN}.png || die
	domenu other/${PN}.desktop || die

	insinto /usr/share/${PN}
	doins -r lang styles || die
}
