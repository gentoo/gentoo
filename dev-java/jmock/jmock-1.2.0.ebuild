# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for testing Java code using mock objects"
SRC_URI="http://${PN}.codehaus.org/dist/${P}-jars.zip"
HOMEPAGE="http://jmock.codehaus.org"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

CDEPEND="dev-java/junit:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="junit"

src_unpack() {
	unpack ${A}
	unzip ${PN}-core-${PV}.jar -d src || die
}

java_prepare() {
	rm *.jar || die
	find -name "*.class" -delete || die
	epatch "${FILESDIR}/1.1.0-junit-3.8.2.patch"
}
