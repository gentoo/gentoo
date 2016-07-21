# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

MY_PV=${PV/.0/}
DESCRIPTION="Myster is a decentralized file sharing network"
HOMEPAGE="http://www.mysternetworks.com/"
SRC_URI="mirror://sourceforge/myster/Myster_PR${MY_PV}_Generic.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}"

src_install () {
	insinto /opt/myster
	doins -r */*
	java-pkg_regjar "${D}"/opt/myster/*.jar
	java-pkg_dolauncher ${PN}
}
