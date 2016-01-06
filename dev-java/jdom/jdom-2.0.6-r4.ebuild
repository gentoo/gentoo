# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="JDOM-${PV}"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="https://github.com/hunterhacker/${PN}/archive/${MY_P}.tar.gz"
HOMEPAGE="http://www.jdom.org"
LICENSE="Apache-1.1"
SLOT="2"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

CDEPEND="
	dev-java/xalan:0
	dev-java/jaxen:1.1
	dev-java/iso-relax:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	test? ( dev-java/ant-junit:0 )"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="jars"
EANT_TEST_TARGET="junit"
EANT_GENTOO_CLASSPATH="iso-relax,jaxen-1.1,xalan"
S="${WORKDIR}/${PN}-${MY_P}"

PATCHES=(
	"${FILESDIR}/build-xml-2.patch"
)

java_prepare() {
	java-pkg_clean

	epatch "${PATCHES[@]}"

	# Remove Android stuff to avoid junit RDEPEND.
	rm -vr contrib/src/java/org/jdom2/contrib/android || die
}

src_install() {
	java-pkg_newjar build/package/${PN}-${SLOT}.x-????.??.??.??.??.jar ${PN}.jar
	java-pkg_newjar build/package/${PN}-${SLOT}.x-????.??.??.??.??-contrib.jar ${PN}-contrib.jar

	dodoc {CHANGES,COMMITTERS,README,TODO}.txt
	use doc && java-pkg_dojavadoc build/apidocs
	use source && java-pkg_dosrc {contrib,core}/src/java/*
}

src_test() {
	java-pkg-2_src_test
}
