# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/electric/electric-9.00.ebuild,v 1.1 2010/12/11 21:41:33 rafaelmartins Exp $

inherit eutils java-pkg-2

DESCRIPTION="Complete Electronic Design Automation (EDA) system that can handle many forms of circuit design"
HOMEPAGE="http://www.gnu.org/software/electric/electric.html"
SRC_URI="mirror://gnu/electric/${PN}Binary-${PV}.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6
	sci-electronics/electronics-menu"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	java-pkg_newjar "${DISTDIR}"/${PN}Binary-${PV}.jar
	newicon com/sun/electric/tool/user/help/helphtml/iconplug.png electric.png
	java-pkg_dolauncher ${PN}
	make_desktop_entry electric "Electric VLSI Design System" electric "Electronics"
}
