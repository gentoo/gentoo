# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

MY_P="jCharts-${PV}"
DESCRIPTION="jCharts is a 100% Java based charting utility that outputs a variety of charts"
HOMEPAGE="http://jcharts.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# tests need X11
RESTRICT=test

CDEPEND="dev-java/batik:1.8
	java-virtuals/servlet-api:3.0"

RDEPEND="${CDEPEND}
	|| ( virtual/jre:1.6 virtual/jre:1.5 )"

DEPEND="${CDEPEND}
	|| ( virtual/jdk:1.6 virtual/jdk:1.5 virtual/jdk:1.4 )"

#RDEPEND="${CDEPEND}
#	>=virtual/jre-1.4"
#DEPEND="${CDEPEND}
#	>=virtual/jdk-1.4
#	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	rm -v *.{jar,war} lib/*.jar || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_BUILD_XML="build/build.xml"
EANT_DOC_TARGET="javadocs"
EANT_GENTOO_CLASSPATH="
	batik-1.8
	servlet-api-3.0
"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar build/*.jar
	dohtml docs/*.html

	use doc && java-pkg_dojavadoc build/javadocs
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples demo
}
