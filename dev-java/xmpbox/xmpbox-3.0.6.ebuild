# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="An open source Java tool that implements Adobe's XMP(TM) specification"
HOMEPAGE="https://pdfbox.apache.org"
SRC_URI="mirror://apache/pdfbox/${PV}/pdfbox-${PV}-src.zip
	verify-sig? ( https://downloads.apache.org/pdfbox/${PV}/pdfbox-${PV}-src.zip.asc )"
S="${WORKDIR}/pdfbox-${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-apache-pdfbox )
"
DEPEND="
	dev-java/jaxb-api:2
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.xmpbox"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-5"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/pdfbox.apache.org.asc"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/pdfbox-${PV}-src.zip{,.asc}
	default
}
