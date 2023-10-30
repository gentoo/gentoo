# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-collections:commons-collections:${PV}"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="https://commons.apache.org/collections/"
SRC_URI="https://archive.apache.org/dist/commons/collections/source/${P}-src.tar.gz
	verify-sig? ( https://archive.apache.org/dist/commons/collections/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
# broken with jdk:21 - https://bugs.gentoo.org/916445
DEPEND="
	<=virtual/jdk-17:*
	test? ( dev-java/junit:0 )
"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {NOTICE,README,RELEASE-NOTES}.txt )
HTML_DOCS=( {DEVELOPERS-GUIDE,PROPOSAL}.html )

PATCHES=( "${FILESDIR}/${P}-fixes.patch" )

JAVA_SRC_DIR="src/java"
JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="src/test"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	if [[ "${ARCH}" = "ppc" ]]; then
		einfo "tests are disabled on ppc"
	else
		java-pkg-simple_src_test
	fi
}
