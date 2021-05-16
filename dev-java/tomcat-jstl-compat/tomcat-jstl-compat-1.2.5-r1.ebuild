# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="taglibs-standard"
MY_P="${MY_PN}-${PV}"
MY_COMPAT="${MY_PN}-compat"

DESCRIPTION="JSP Standard Tag Library (JSTL) - Compat jar"
HOMEPAGE="https://tomcat.apache.org/taglibs/standard/"
SRC_URI="http://apache.mirrors.ovh.net/ftp.apache.org/dist/tomcat/taglibs/${MY_P}/${MY_P}-source-release.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-java/tomcat-jstl-spec:0
	dev-java/tomcat-jstl-impl:0
	java-virtuals/servlet-api:3.0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	test? (
		dev-java/ant-junit:0
		dev-java/easymock:3.2
	)
	>=virtual/jdk-1.6"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="servlet-api-3.0,tomcat-jstl-spec,tomcat-jstl-impl"
EANT_BUILD_TARGET="package"
EANT_BUILD_XML="compat/build.xml"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml "${S}"/compat/build.xml || die
}

EANT_TEST_TARGET="test"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},easymock-3.2"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "${S}"/compat/target/${MY_COMPAT}-${PV}.jar ${MY_COMPAT}.jar

	if use doc; then
		java-pkg_dohtml -r "${S}"/compat/target/site/apidocs/
	fi

	if use source; then
		java-pkg_dosrc "${S}"/compat/src/*
	fi
}
