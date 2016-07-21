# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Small XML Pull Parser"
HOMEPAGE="http://kxml.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}2-src-${PV}.zip"

LICENSE="BSD"
SLOT="2"
KEYWORDS="amd64 ppc64 x86"

CDEPEND="dev-java/xpp3:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}"

java_prepare() {
	java-pkg_clean
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="build_jar"
EANT_GENTOO_CLASSPATH="xpp3"

src_install() {
	java-pkg_newjar dist/${PN}2-${PV}.jar ${PN}.jar
	java-pkg_newjar dist/${PN}2-min-${PV}.jar ${PN}-min.jar

	use source && java-pkg_dosrc src/org
	use doc && java-pkg_dojavadoc www/kxml2/javadoc
	use examples && java-pkg_doexamples samples
}
