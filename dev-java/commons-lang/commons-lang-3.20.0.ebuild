# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="https://commons.apache.org/proper/commons-lang/"
SRC_URI="mirror://apache/commons/lang/source/${PN}3-${PV}-src.tar.gz -> ${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/lang/source/${PN}3-${PV}-src.tar.gz.asc -> ${P}-src.tar.gz.asc )"
S="${WORKDIR}/${PN}3-${PV}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x64-solaris"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

# [-vintage] because, if junit:5 compiled with 'USE=vintage':
# Error: Module junit not found, required by org.junit.vintage.engine
DEPEND="
	>=virtual/jdk-11:*
	test? (
		>=dev-java/asm-9.9:0
		>=dev-java/commons-text-1.14.0:0
		>=dev-java/easymock-5.6.0:0
		>=dev-java/jmh-core-1.37:0
		dev-java/junit:5[-vintage]
		>=dev-java/junit-pioneer-1.9.1-r1:0
		>=dev-java/jsr305-3.0.2-r1:0
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/commons-lang-3.19.0-skip-testGetJavaAwtHeadless.patch" )

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.lang3"
JAVA_GENTOO_CLASSPATH_EXTRA="org.apache.commons.lang3.jar"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}3"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm commons-text easymock jmh-core junit-pioneer junit-5 jsr305 opentest4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.{lang,util,time,time.chrono}=ALL-UNNAMED )
	fi
	LC_ALL="en_US.UTF-8" junit5_src_test
}
