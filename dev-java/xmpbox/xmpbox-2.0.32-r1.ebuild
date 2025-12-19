# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.pdfbox:xmpbox:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="An open source Java tool that implements Adobe's XMP(TM) specification"
HOMEPAGE="https://pdfbox.apache.org"
SRC_URI="mirror://apache/pdfbox/${PV}/pdfbox-${PV}-src.zip
	verify-sig? ( https://downloads.apache.org/pdfbox/${PV}/pdfbox-${PV}-src.zip.asc )"
S="${WORKDIR}/pdfbox-${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 arm64 ppc64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/pdfbox.apache.org.asc"
BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-apache-pdfbox )
"
CP_DEPEND="dev-java/jaxb-api:2"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.xmpbox"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached \
			"${DISTDIR}/pdfbox-${PV}-src.zip" \
			"${DISTDIR}/pdfbox-${PV}-src.zip.asc"
	fi
	default
}

JAVA_TEST_EXCLUDES=(
	# 1) initializationError(org.apache.xmpbox.parser.PropMappingTest)
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'org.apache.xmpbox.parser.PropMappingTest':
	#   1. No runnable methods
	org.apache.xmpbox.parser.PropMappingTest
)
