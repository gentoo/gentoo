# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jaxen:jaxen:2.0.0"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jaxen is a universal XPath engine for Java"
HOMEPAGE="http://www.cafeconleche.org/jaxen/"
SRC_URI="https://github.com/${PN}-xpath/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/core"

LICENSE="BSD-2"
SLOT="1.2"
KEYWORDS="amd64 arm64 ppc64"
IUSE="dom4j jdom xom"

# It seems that most tests depend on dom4j, jdom and xom which all depend back on jaxen
REQUIRED_USE="test? ( dom4j jdom xom )"

CDEPEND="
	dom4j? ( >=dev-java/dom4j-2.2.0:0 )
	jdom? ( dev-java/jdom:0 )
	xom? ( dev-java/xom:0 )
"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="org.jaxen"
JAVA_SRC_DIR="src/java/main"

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="src/java/test"

src_prepare() {
	java-pkg-2_src_prepare

	if use dom4j; then
		JAVA_GENTOO_CLASSPATH+=" dom4j"
	else
		rm -rv "${JAVA_SRC_DIR}"/org/jaxen/dom4j || die
	fi

	if use jdom; then
		JAVA_GENTOO_CLASSPATH+=" jdom"
	else
		rm -rv "${JAVA_SRC_DIR}"/org/jaxen/jdom || die
	fi

	if use xom; then
		JAVA_GENTOO_CLASSPATH+=" xom"
	else
		rm -rv "${JAVA_SRC_DIR}"/org/jaxen/xom || die
	fi
}
