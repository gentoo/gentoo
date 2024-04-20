# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-collections4:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Extends the JCF classes with new interfaces, implementations and utilities"
HOMEPAGE="https://commons.apache.org/proper/commons-collections/"
SRC_URI="mirror://apache/commons/collections/source/${PN}4-${PV}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/collections/source/${PN}4-${PV}-src.tar.gz.asc )"
S="${WORKDIR}/commons-collections4-${PV}-src"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
# broken with jdk:21 - https://bugs.gentoo.org/916445
DEPEND="
	<=virtual/jdk-17:*
	test? (
		dev-java/easymock:3.2
		dev-java/commons-lang:3.6
	)
"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README}.md {NOTICE,RELEASE-NOTES}.txt )
HTML_DOCS=( {DEVELOPERS-GUIDE,PROPOSAL}.html )

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.collections4"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	commons-lang-3.6
	easymock-3.2
	junit-4
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# https://github.com/apache/commons-collections/blob/commons-commons-collections-4.4/pom.xml#L542-L550
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*Test.java" \
			! -name "TestUtils.java" \
			! -name "Abstract*.java" \
			! -name "BulkTest.java")
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd
	java-pkg-simple_src_test
}
