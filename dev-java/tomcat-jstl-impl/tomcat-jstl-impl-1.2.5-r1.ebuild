# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="taglibs-standard"
MY_P="${MY_PN}-${PV}"
MY_IMPL="${MY_PN}-impl"

DESCRIPTION="JSP Standard Tag Library (JSTL) - Implementation jar"
HOMEPAGE="https://tomcat.apache.org/taglibs/standard/"
SRC_URI="http://apache.mirrors.ovh.net/ftp.apache.org/dist/tomcat/taglibs/${MY_P}/${MY_P}-source-release.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-java/xalan:0
	dev-java/tomcat-jstl-spec:0
	dev-java/tomcat-servlet-api:3.1"

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
EANT_GENTOO_CLASSPATH="tomcat-servlet-api-3.1,tomcat-jstl-spec,xalan"
EANT_BUILD_TARGET="package"
EANT_BUILD_XML="impl/build.xml"

JAVA_RM_FILES=(
	impl/src/test/java/org/apache/taglibs/standard/tag/common/fmt/BundleSupportTest.java
)

PATCHES=(
	# This patch overrides a couple of methods.
	"${FILESDIR}"/${P}-ImportSupport.patch
	# This one disables one test case which doesn't work.
	"${FILESDIR}"/${P}-SetSupport.patch
)

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml "${S}"/impl/build.xml || die

	epatch "${PATCHES[@]}"
}

EANT_TEST_TARGET="test"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},easymock-3.2"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "${S}"/impl/target/${MY_IMPL}-${PV}.jar ${MY_IMPL}.jar

	if use doc; then
		java-pkg_dohtml -r "${S}"/impl/target/site/apidocs/
	fi

	if use source; then
		java-pkg_dosrc "${S}"/impl/src/*
	fi
}
