# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="xmlunit:xmlunit:1.6"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML"
HOMEPAGE="https://sourceforge.net/projects/xmlunit/ https://www.xmlunit.org"
SRC_URI="mirror://sourceforge/project/xmlunit/xmlunit%20for%20Java/XMLUnit%20for%20Java%20${PV}/${P}-src.zip"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 ~arm64 ppc64 x86"

BDEPEND="app-arch/unzip"
CP_DEPEND="dev-java/junit:0"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	doc? ( app-text/docbook-xsl-stylesheets:0 )
	test? ( >=dev-java/ant-1.10.14:0[junit] )
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/java"
JAVA_TEST_EXTRA_ARGS=( -Dbasedir="." )
JAVA_TEST_RESOURCE_DIRS="tests/etc"
JAVA_TEST_SRC_DIR="tests/java"

src_install() {
	java-pkg-simple_src_install
	if use doc; then
		docinto html
		dodoc -r userguide
	fi
}
