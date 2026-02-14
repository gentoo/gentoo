# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Command line parsing framework for Java"
HOMEPAGE="https://github.com/cbeust/jcommander"
SRC_URI="https://github.com/cbeust/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/jackson-annotations-2.20:0
		>=dev-java/jackson-core-2.20.0:0
		>=dev-java/testng-7.11.0:0
	)
"
RDEPEND=">=virtual/jre-1.8:* "

PATCHES=( "${FILESDIR}/jcommander-1.83-skipFailingTest.patch" )

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="jackson-annotations jackson-core slf4j-simple testng"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY="src/test/resources/testng.xml"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
#	default #bug #780585
	java-pkg-2_src_prepare
	java-pkg_clean

	# because module java.base does not export sun.reflect.annotation to unnamed module @0x42bb2aee
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/sun.reflect.annotation=ALL-UNNAMED )
	fi
}
