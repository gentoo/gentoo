# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:jbig2-imageio:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="PDFBox JBIG2 ImageIO plugin"
HOMEPAGE="https://pdfbox.apache.org"
SRC_URI="https://downloads.apache.org/pdfbox/${PN}/${PV}/${P}-src.zip
	verify-sig? ( https://downloads.apache.org/pdfbox/${PN}/${PV}/${P}-src.zip.asc )"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/pdfbox.apache.org.asc"
BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-apache-pdfbox )
"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.pdfbox.jbig2"
JAVA_RESOURCE_DIRS="${P}/src/main/resources"
JAVA_SRC_DIR="${P}/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="${P}/src/test/resources"
JAVA_TEST_SRC_DIR="${P}/src/test/java"

JAVA_TEST_EXCLUDES=(
	# org.junit.runners.model.InvalidTestClassError: Invalid test class
	#  1. Test class should have exactly one public constructor
	"org.apache.pdfbox.jbig2.util.TestServiceImpl"
	"org.apache.pdfbox.jbig2.util.TestService"
)
