# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="XML Graphics Commons"
HOMEPAGE="https://xmlgraphics.apache.org/commons/"
SRC_URI="mirror://apache/xmlgraphics/commons/source/${P}-src.tar.gz
	verify-sig? ( mirror://apache/xmlgraphics/commons/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-xmlgraphics )"

# Using older commons-io because of compilation error with newer versions:
# src/main/java/org/apache/xmlgraphics/image/loader/impl/ImageLoaderRawJPEG.java:231:
# error: exception IOException is never thrown in body of corresponding try statement
#                } catch (IOException ioe) {
#                  ^
CP_DEPEND="
	dev-java/commons-io:1
	>=dev-java/commons-logging-1.3.6:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/mockito-4.11.0:4
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
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/apache-xmlgraphics.asc"
