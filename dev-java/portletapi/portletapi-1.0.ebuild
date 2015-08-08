# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

JETSPEED_P="jetspeed-2.0-src"
DESCRIPTION="Jetspeed 2 Portlet API implementation of JSR 168"
HOMEPAGE="http://portals.apache.org/jetspeed-2/"
SRC_URI="mirror://apache/portals/jetspeed-2/sources/${JETSPEED_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${JETSPEED_P}/portlet-api"

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}/${P}-build.xml" "${S}/build.xml" || die
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/javax
}
