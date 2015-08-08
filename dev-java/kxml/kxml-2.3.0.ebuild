# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Small XML pull parser for constrained environments such as Applets, Personal Java or MIDP devices"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}2-src-${PV}.zip"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"

CDEPEND="dev-java/xpp3:0"

DEPEND=">=virtual/jdk-1.4
	${CDEPEND}
	app-arch/unzip"

RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

S="${WORKDIR}"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die

	find . -name '*.class' -print -delete || die
	find . -name '*.jar' -print -delete || die
}

EANT_BUILD_TARGET="build_jar"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="xpp3"

src_install() {
	java-pkg_newjar dist/${PN}2-${PV}.jar ${PN}.jar
	java-pkg_newjar dist/${PN}2-min-${PV}.jar ${PN}-min.jar

	use source && java-pkg_dosrc src/org
	use doc && java-pkg_dojavadoc www/kxml2/javadoc
	use examples && java-pkg_doexamples samples
}
