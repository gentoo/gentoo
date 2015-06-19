# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xpp2/xpp2-2.1.10-r1.ebuild,v 1.22 2013/06/27 21:40:45 aballier Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="PullParser"
MY_P="${MY_PN}${PV}"
DESCRIPTION="A streaming pull XML parser used to quickly process input elements"
HOMEPAGE="http://www.extreme.indiana.edu/xgws/xsoap/xpp/mxp1/index.html"
SRC_URI="http://www.extreme.indiana.edu/xgws/xsoap/xpp/download/${MY_PN}2/${MY_P}.tgz"

LICENSE="Apache-1.1 IBM"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
S="${WORKDIR}/${MY_P}"

CDEPEND="dev-java/xerces:2"
DEPEND=">=virtual/jdk-1.3
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.3
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v lib/*/*.jar build/*/*.jar || die
	find build/ -name '*.jar' -o -name '*.class' -delete

	# add xercesImpl.jar to relevant javac classpaths
	java-ant_xml-rewrite -f build.xml -e javac -a classpath -i 7 -c -v \
		'${build_intf}:lib/xercesImpl.jar' -i 7
	java-ant_xml-rewrite -f build.xml -e javac -a classpath -i 8 -c -v \
		'${build_intf}:${build_impl_tag}:${build_x2impl_pp}:${build_impl_node}:${build_impl_format}:lib/xercesImpl.jar'

	cd lib
	java-pkg_jar-from xerces-2
}

# override check for xerces-2 presence
EANT_EXTRA_ARGS="-Dx2_present=true"
EANT_BUILD_TARGET="compile"
EANT_DOC_TARGET="api"

src_install() {
	java-pkg_newjar build/lib/${MY_PN}-${PV}.jar ${MY_PN}.jar
	java-pkg_newjar build/lib/${MY_PN}-intf-${PV}.jar ${MY_PN}-intf.jar
	java-pkg_newjar build/lib/${MY_PN}-standard-${PV}.jar ${MY_PN}-standard.jar
	java-pkg_newjar build/lib/${MY_PN}-x2-${PV}.jar ${MY_PN}-x2.jar

	dohtml README.html || die
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/java/*
}
