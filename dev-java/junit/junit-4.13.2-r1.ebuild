# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="junit:junit:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simple framework to write repeatable tests"
HOMEPAGE="https://junit.org/junit4/"
SRC_URI="https://github.com/${PN}-team/${PN}4/archive/r${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}4-r${PV}"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

CP_DEPEND="dev-java/hamcrest-core:1.3"
# not suitable for jdk:21 #916398
DEPEND="${CP_DEPEND}
	<=virtual/jdk-17:*
	test? ( dev-java/hamcrest-library:1.3 )"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="junit"
JAVA_ENCODING="ISO-8859-1"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="hamcrest-core-1.3,hamcrest-library-1.3"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_test() {
	cd "${JAVA_TEST_SRC_DIR}" || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars ${JAVA_TEST_GENTOO_CLASSPATH})"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	# pom.xml lines 264-268
	java -cp "${CP}" -Djava.awt.headless=true \
		org.junit.runner.JUnitCore org.junit.tests.AllTests || die "Running junit failed"
}
