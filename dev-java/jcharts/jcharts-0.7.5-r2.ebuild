# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jcharts/jcharts-0.7.5-r2.ebuild,v 1.4 2013/11/11 23:16:12 mr_bones_ Exp $

EAPI="4"

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

# depends on com.sun.image.codec.jpeg which was removed in java 1.7 #180437
COMMON_DEP="
	dev-java/batik:1.7
	java-virtuals/servlet-api:3.0"
RDEPEND="${COMMON_DEP}
	|| ( virtual/jre:1.6 virtual/jre:1.5 )"
DEPEND="${COMMON_DEP}
	|| ( virtual/jdk:1.6 virtual/jdk:1.5 virtual/jdk:1.4 )
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	rm -v *.{jar,war} lib/*.jar || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_BUILD_XML="build/build.xml"
EANT_GENTOO_CLASSPATH="batik-1.7,servlet-api-3.0"
EANT_DOC_TARGET="javadocs"

#src_test() {
#	java-pkg-2_src_test
#}

src_install() {
	java-pkg_newjar build/*.jar
	dohtml docs/*.html

	use doc && java-pkg_dojavadoc build/javadocs
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples demo
}
