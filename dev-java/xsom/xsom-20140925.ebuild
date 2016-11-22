# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XSOM is a Java library allows to easily parse and inspect XML schema docs"
HOMEPAGE="https://xsom.dev.java.net/"
SRC_URI="https://repo1.maven.org/maven2/com/sun/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="CDDL"
IUSE=""

CDEPEND="dev-java/relaxng-datatype:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="relaxng-datatype"
