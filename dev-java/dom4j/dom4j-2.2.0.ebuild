# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.dom4j:dom4j:2.2.0"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="flexible XML framework for Java"
HOMEPAGE="https://dom4j.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/version/${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/jaxen/jaxen/1.2.0/jaxen-1.2.0.jar"
S="${WORKDIR}/${PN}-version-${PV}"

LICENSE="dom4j"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="jaxen"

CP_DEPEND="
	>=dev-java/jaxb-api-4.0.2:4
	dev-java/xpp2:0
	dev-java/xpp3:0
	dev-java/xsdlib:0
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*
	jaxen? ( dev-java/jaxen:1.2[dom4j] )
	test? ( dev-java/xerces:2 )
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
	jaxen? ( dev-java/jaxen:1.2[dom4j] )
"

JAVA_AUTOMATIC_MODULE_NAME="org.dom4j"

# dom4j has a cyclic dependency on jaxen[dom4j].
# The downloaded jaxen-1.2.0.jar is provided for compilation only.
# No prebuilt software is actually installed onto the system.
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/jaxen-1.2.0.jar"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="testng,xerces-2"
JAVA_TEST_RESOURCE_DIRS="xml"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean ..

	if use jaxen; then
		JAVA_GENTOO_CLASSPATH+=" jaxen-1.2"
	fi
}
