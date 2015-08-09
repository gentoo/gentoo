# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="taglibs-standard"
MY_P="${MY_PN}-${PV}"
MY_SPEC="${MY_PN}-spec"

DESCRIPTION="JSP Standard Tag Library (JSTL) - Specification jar"
HOMEPAGE="https://tomcat.apache.org/taglibs/standard/"
SRC_URI="http://apache.mirrors.ovh.net/ftp.apache.org/dist/tomcat/taglibs/${MY_P}/${MY_P}-source-release.zip"

LICENSE="Apache-2.0"
SLOT="1.2.5"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="java-virtuals/servlet-api:3.0"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
		dev-java/easymock:3.2
	)
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="servlet-api-3.0"
EANT_BUILD_TARGET="package"
EANT_BUILD_XML="spec/build.xml"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml "${S}"/spec/build.xml
}

EANT_TEST_TARGET="test"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},easymock-3.2"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "${S}"/spec/target/${MY_SPEC}-${PV}.jar ${MY_SPEC}.jar

	if use doc; then
		java-pkg_dohtml -r "${S}"/spec/target/site/apidocs/
	fi

	if use source; then
		java-pkg_dosrc "${S}"/spec/src/*
	fi
}
