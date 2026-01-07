# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="junit:junit:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simple framework to write repeatable tests"
HOMEPAGE="https://junit.org/junit4/"
MY_COMMIT="28fa2cae48b365c949935b28967ffb3f388e77ef"
SRC_URI="https://github.com/${PN}-team/${PN}4/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}4-${MY_COMMIT}"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

CP_DEPEND="dev-java/hamcrest-core:1.3"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/hamcrest-library:1.3 )"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/junit-4.13.2_p20240222-ignore-failing-test.patch" )

JAVA_AUTOMATIC_MODULE_NAME="junit"
JAVA_ENCODING="ISO-8859-1"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="hamcrest-core-1.3,hamcrest-library-1.3"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	cd "${JAVA_TEST_SRC_DIR}" || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars \
		--build-only ${JAVA_TEST_GENTOO_CLASSPATH})"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	# pom.xml lines 264-268
	java -cp "${CP}" -Djava.awt.headless=true \
		org.junit.runner.JUnitCore org.junit.tests.AllTests || die "Running junit failed"
}
