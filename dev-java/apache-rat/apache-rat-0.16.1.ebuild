# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Apache Rat is a release audit tool, focused on licenses"
HOMEPAGE="https://creadur.apache.org/rat/"
SRC_URI="https://archive.apache.org/dist/creadur/${P}/${P}-src.tar.bz2
	verify-sig? ( https://downloads.apache.org/creadur/${P}/${P}-src.tar.bz2.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-pottlinger )"
CP_DEPEND="
	>=dev-java/ant-1.10.15:0
	>=dev-java/commons-beanutils-1.11.0:0
	>=dev-java/commons-cli-1.10.0:0
	>=dev-java/commons-collections-4.5.0:4
	>=dev-java/commons-compress-1.28.0:0
	>=dev-java/commons-io-2.20.0:0
	>=dev-java/commons-lang-3.19.0:0
"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/ant-1.10.15:0[junit,testutil]
		>=dev-java/assertj-core-3.27.6:0
		dev-java/junit:5[vintage]
		>=dev-java/mockito-5.20.0:0
	)
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( NOTICE README.md README.txt RELEASE-NOTES.txt RELEASE_NOTES.txt )
JAVA_RESOURCE_DIRS=( apache-rat-{core,tasks}/src/main/resources )
JAVA_SRC_DIR=( apache-rat-{core,tasks}/src/main/java )
JAVA_TEST_GENTOO_CLASSPATH="assertj-core junit-5 mockito"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/pottlinger.asc"

src_test() {
	rm -r src || die
	mv "${PN}-core/src" . || die
	junit5_src_test

	mv -v target/test-classes . || die
	JAVA_GENTOO_CLASSPATH_EXTRA+=":test-classes"

	rm -r src || die
	mv "${PN}-tasks/src" . || die
	junit5_src_test
}
