# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="taglibs-standard"
MY_P="${MY_PN}-${PV}"
MY_EL="${MY_PN}-jstlel"

DESCRIPTION="JSP Standard Tag Library (JSTL) - EL jar"
HOMEPAGE="https://tomcat.apache.org/taglibs/standard/"
SRC_URI="http://apache.mirrors.ovh.net/ftp.apache.org/dist/tomcat/taglibs/${MY_P}/${MY_P}-source-release.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

CDEPEND="
	dev-java/tomcat-jstl-impl:0
	dev-java/tomcat-jstl-spec:0
	java-virtuals/servlet-api:3.0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	test? (
		dev-java/ant-junit:0
		dev-java/easymock:3.2
	)
	>=virtual/jdk-1.6"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="servlet-api-3.0,tomcat-jstl-spec,tomcat-jstl-impl"
EANT_BUILD_TARGET="package"
EANT_BUILD_XML="jstlel/build.xml"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml "${S}"/jstlel/build.xml || die
}

EANT_TEST_TARGET="test"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},easymock-3.2"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "${S}"/jstlel/target/${MY_EL}-${PV}.jar ${MY_EL}.jar

	if use doc; then
		java-pkg_dohtml -r "${S}"/jstlel/target/site/apidocs/
	fi

	if use source; then
		java-pkg_dosrc "${S}"/jstlel/src/*
	fi
}
