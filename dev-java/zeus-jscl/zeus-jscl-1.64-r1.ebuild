# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2

MY_P="${PN}_v${PV//./_}"

DESCRIPTION="Zeus Java Swing Components Library"
HOMEPAGE="http://sourceforge.net/projects/zeus-jscl/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
}

src_install() {
	java-pkg_newjar lib/${P}.jar ${PN}.jar
	use source && java-pkg_dosrc src
	use doc && java-pkg_dojavadoc doc/api
}
