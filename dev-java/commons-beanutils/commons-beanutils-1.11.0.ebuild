# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-beanutils:commons-beanutils:1.11.0"
JAVA_TESTING_FRAMEWORKS="junit-vintage"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Provides easy-to-use wrappers around Reflection and Introspection APIs"
HOMEPAGE="https://commons.apache.org/proper/commons-beanutils/"
# We need some test classes of commons-collections which are not part of the jar file.
ACC="commons-collections-3.2.2"
SRC_URI="mirror://apache/commons/beanutils/source/${P}-src.tar.gz
	test? ( https://archive.apache.org/dist/commons/collections/source/${ACC}-src.tar.gz )
	verify-sig? ( https://downloads.apache.org/commons/beanutils/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos"
IUSE="log4j"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ggregory )"

COMMON_DEPEND="
	dev-java/commons-collections:0
	>=dev-java/commons-logging-1.3.5:0[log4j=]
	log4j? (
		dev-java/log4j-12-api:2
		dev-java/log4j-api:2
	)
"

DEPEND="
	${COMMON_DEPEND}
	dev-java/jakarta-servlet-api:4
	dev-java/slf4j-api:0
	>=virtual/jdk-11:*
	test? (
		dev-java/junit:4
		dev-java/junit:5[vintage]
		dev-java/opentest4j:0
	)
"
RDEPEND="
	${COMMON_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {CONTRIBUTING,README}.md {NOTICE,RELEASE-NOTES}.txt )
PATCHES=( "${FILESDIR}/commons-beanutils-1.11.0-skipFailingTest.patch" )

JAVA_CLASSPATH_EXTRA="jakarta-servlet-api-4 slf4j-api"
JAVA_GENTOO_CLASSPATH="commons-collections commons-logging"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4 junit-5 opentest4j"
JAVA_TEST_RESOURCE_DIRS="data"
JAVA_TEST_SRC_DIR=( src/test/java ../"${ACC}"-src/src/test )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ggregory.asc"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	fi
	default
}

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	if use log4j; then
		JAVA_GENTOO_CLASSPATH+="
			log4j-12-api-2
			log4j-api-2
		"
	fi

	if use test; then
		# Apply patch to unpacked commons-collections
		pushd "../${ACC}-src" >> /dev/null || die
			eapply "${FILESDIR}/${ACC}-fixes.patch"
		popd

		cp -r ../"${ACC}"-src/data . || die "copy test data"
	fi

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.{io,lang,util,time,time.chrono}=ALL-UNNAMED )
	fi
}
