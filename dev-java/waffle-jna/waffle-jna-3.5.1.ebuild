# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Enable drop-in Windows Single Sign On for popular Java web servers"
HOMEPAGE="https://waffle.github.io/waffle/"
SRC_URI="https://github.com/Waffle/waffle/archive/waffle-${PV}.tar.gz"
S="${WORKDIR}/waffle-waffle-${PV}/Source/JNA/waffle-jna"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-java/caffeine-2.9.3:0
	>=dev-java/checker-framework-qual-3.52.1:0
	dev-java/jakarta-servlet-api:4
	>=dev-java/jna-5.18.1:0
	>=dev-java/slf4j-api-2.0.3:0
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/assertj-core-3.27.6:0
		>=dev-java/powermock-reflect-2.0.9:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="waffle.jna"
JAVA_CLASSPATH_EXTRA="caffeine checker-framework-qual jakarta-servlet-api-4 jna slf4j-api"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXCLUDES=(
	waffle.util.WaffleInfoTest
	waffle.windows.auth.WindowsAccountTest
	waffle.windows.auth.WindowsCredentialsHandleTest
	waffle.windows.auth.WindowsSecurityContextTest
)
JAVA_TEST_GENTOO_CLASSPATH="assertj-core jna junit-5 powermock-reflect"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	rm src/test/java/waffle/jaas/WindowsLoginModuleTest.java || die
	rm src/test/java/waffle/servlet/CorsAwareNegotiateSecurityFilterTest.java || die
	rm src/test/java/waffle/servlet/NegotiateSecurityFilterTest.java || die
	rm src/test/java/waffle/servlet/WindowsPrincipalTest.java || die
	rm src/test/java/waffle/util/CorsPreFlightCheckTest.java || die
	java-pkg-2_src_prepare
}
