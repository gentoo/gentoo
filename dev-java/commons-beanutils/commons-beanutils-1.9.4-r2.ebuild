# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-beanutils:commons-beanutils:1.9.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Provides easy-to-use wrappers around Reflection and Introspection APIs"
HOMEPAGE="https://commons.apache.org/proper/commons-beanutils/"
# We need some test classes of commons-collections which are not part of the jar file.
ACC="commons-collections-3.2.2"
SRC_URI="mirror://apache/commons/beanutils/source/${P}-src.tar.gz
	test? ( https://archive.apache.org/dist/commons/collections/source/${ACC}-src.tar.gz )
	verify-sig? ( https://downloads.apache.org/commons/beanutils/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="1.7"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
CP_DEPEND="
	dev-java/commons-collections:0
	dev-java/commons-logging:0
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README}.md {NOTICE,RELEASE-NOTES}.txt )

JAVA_ENCODING="iso-8859-1"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4 "
JAVA_TEST_SRC_DIR=(
	src/test/java
	../"${ACC}"-src/src/test
)

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	fi
	default
}

src_test() {
	export LC_ALL="en_US.UTF-8"
	# Apply patch to unpacked commons-collections
	pushd "../${ACC}-src" >> /dev/null || die
		eapply "${FILESDIR}/${ACC}-fixes.patch"
	popd

	pushd src/test/java || die
		# Selection according to lines 375-383 pom.xml
		local JAVA_TEST_RUN_ONLY=$(find * \
			-path "**/*TestCase.java" \
			! -path "**/*MemoryTestCase.java" \
			! -path "**/*MemoryLeakTestCase.java" \
			! -path "**/*LocaleBeanificationTestCase.java" \
			! -path "**/Jira347TestCase.java" \
			)
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"

	# We skip 2 more test classes conditionally which have failures with Java 21
	# Error converting 'String' to 'java.sql.Time' using pattern 'h:mm a'
	# Error converting 'String' to 'java.sql.Timestamp' using pattern 'M/d/yy, h:mm a'
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "21"; then
		JAVA_TEST_RUN_ONLY=${JAVA_TEST_RUN_ONLY//org.apache.commons.beanutils.converters.SqlTimeConverterTestCase}
		JAVA_TEST_RUN_ONLY=${JAVA_TEST_RUN_ONLY//org.apache.commons.beanutils.converters.SqlTimestampConverterTestCase}
	fi

	java-pkg-simple_src_test
}
