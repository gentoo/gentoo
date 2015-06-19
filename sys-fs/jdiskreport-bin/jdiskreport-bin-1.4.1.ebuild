# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/jdiskreport-bin/jdiskreport-bin-1.4.1.ebuild,v 1.1 2014/03/01 16:31:37 ercpe Exp $

EAPI=5

inherit java-pkg-2

MY_PN=${PN/-bin/}
MY_PV=${PV//\./_}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="JDiskReport helps you to understand disk drive usage"
HOMEPAGE="http://www.jgoodies.com/freeware/jdiskreport/"
SRC_URI="http://www.jgoodies.com/download/${MY_PN}/${MY_P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.6"

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	java-pkg_newjar ${MY_PN}-${PV}.jar
	java-pkg_dolauncher ${MY_PN}

	dodoc README.txt RELEASE-NOTES.txt || die
}
