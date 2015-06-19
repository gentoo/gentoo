# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/zeus-jscl/zeus-jscl-1.64.ebuild,v 1.2 2013/02/18 12:55:20 jlec Exp $

EAPI="2"

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2

MY_P="${PN}_v${PV//./_}"

DESCRIPTION="Zeus Java Swing Components Library"
HOMEPAGE="http://sourceforge.net/projects/zeus-jscl/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=""
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	java-pkg_newjar lib/${P}.jar ${PN}.jar
	use source && java-pkg_dosrc src
	use doc && java-pkg_dojavadoc doc/api
}
