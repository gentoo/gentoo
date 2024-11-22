# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.xmlgraphics:xmlgraphics-commons:2.10"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="XML Graphics Commons"
HOMEPAGE="https://xmlgraphics.apache.org/commons/"
SRC_URI="mirror://apache/xmlgraphics/commons/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/xmlgraphics/commons/source/${P}-src.tar.gz.asc )"

S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/xmlgraphics-commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-xmlgraphics-commons )"

CP_DEPEND="
	dev-java/commons-io:1
	dev-java/commons-logging:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/mockito:4
		dev-java/xml-commons-resolver:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( NOTICE README )

JAVA_AUTOMATIC_MODULE_NAME="org.apache.xmlgraphics.commons"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXTRA_ARGS=( -ea )
JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-4,xml-commons-resolver"
# Some *.{png,tiff,txt,xmp} are misplaced in "src/test/java".
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" "src/test/java" )
JAVA_TEST_SRC_DIR="src/test/java"
