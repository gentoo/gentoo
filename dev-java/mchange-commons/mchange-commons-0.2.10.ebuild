# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-pkg-simple

MY_PN="${PN}-java"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="a library of arguably useful Java utilities"
HOMEPAGE="https://github.com/swaldman/mchange-commons-java"
SRC_URI="https://github.com/swaldman/${MY_PN}/archive/${MY_P}.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc ~ppc64"

IUSE="doc source"

CDEPEND="
	dev-java/log4j:0
	dev-java/slf4j-api:0
	dev-java/typesafe-config:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/zip
	>=virtual/jdk-1.6"

S="${WORKDIR}/${MY_PN}-${MY_P}"

JAVA_SRC_DIR="src/main"

JAVA_GENTOO_CLASSPATH="
	log4j
	slf4j-api
	typesafe-config"
