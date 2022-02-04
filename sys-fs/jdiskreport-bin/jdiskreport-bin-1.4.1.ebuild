# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PN=${PN/-bin/}
MY_PV=${PV//\./_}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="JDiskReport helps you to understand disk drive usage"
HOMEPAGE="http://www.jgoodies.com/freeware/jdiskreport/"
SRC_URI="http://www.jgoodies.com/download/${MY_PN}/${MY_P}.zip"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.6"
BDEPEND="app-arch/unzip"

src_install() {
	java-pkg_newjar ${MY_PN}-${PV}.jar
	java-pkg_dolauncher ${MY_PN}

	dodoc README.txt RELEASE-NOTES.txt
}
