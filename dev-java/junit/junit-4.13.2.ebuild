# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom junit4-r4.13.2/pom.xml --download-uri https://github.com/junit-team/junit4/archive/refs/tags/r4.13.2.tar.gz --slot 4 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild junit-4.13.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="junit:junit:4.13.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simple framework to write repeatable tests"
HOMEPAGE="https://junit.org/junit5/"
SRC_URI="https://github.com/${PN}-team/${PN}4/archive/refs/tags/r${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

# Common dependencies
# POM: ${PN}4-r${PV}/pom.xml
# org.hamcrest:hamcrest-core:1.3 -> >=dev-java/hamcrest-core-1.3:1.3

CDEPEND="
	dev-java/hamcrest-core:1.3
"

# Compile dependencies
# POM: ${PN}4-r${PV}/pom.xml
# test? org.hamcrest:hamcrest-library:1.3 -> >=dev-java/hamcrest-library-1.3:1.3

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/hamcrest-library:1.3
	)
	${CDEPEND}"
RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}"

JAVA_ENCODING="ISO-8859-1"

JAVA_GENTOO_CLASSPATH="hamcrest-core-1.3"
JAVA_SRC_DIR="${PN}4-r${PV}/src/main/java"
JAVA_RESOURCE_DIRS="${PN}4-r${PV}/src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="hamcrest-core-1.3,hamcrest-library-1.3"
JAVA_TEST_SRC_DIR="${PN}4-r${PV}/src/test/java"
JAVA_TEST_RESOURCE_DIRS="${PN}4-r${PV}/src/test/resources"

src_prepare() {
	default
	java-pkg_clean
}

src_test() {
	cd "${JAVA_TEST_SRC_DIR}" || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars ${JAVA_TEST_GENTOO_CLASSPATH})"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	java -cp "${CP}" -Djava.awt.headless=true org.junit.runner.JUnitCore junit.tests.AllTests || die "Running junit failed"
}
