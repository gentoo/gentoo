# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=4

inherit java-pkg-2 java-ant-2

SRC_URI="mirror://gentoo/${P}.tar.bz2"
MY_PV=${PV//./_}
MY_PVR="${MY_PV}-r43"

DESCRIPTION="Simplified Java NIO asynchronous sockets"
HOMEPAGE="https://code.google.com/p/naga/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.5"

src_compile() {
	eant build
}

src_install() {
	java-pkg_newjar _DIST/${PN}-${MY_PVR}.jar ${PN}.jar
}
