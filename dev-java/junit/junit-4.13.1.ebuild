# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN}${PV%%.*}"
MY_P="${MY_PN}-r${PV}"
JAVA_PKG_IUSE="doc source"
MAVEN_ID="junit:junit:4.13.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simple framework to write repeatable tests"
HOMEPAGE="https://junit.org/junit5/"
SRC_URI="https://github.com/${PN}-team/${MY_PN}/archive/r${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"

DEPEND="
	dev-java/hamcrest-core:1.3
	dev-java/hamcrest-library:1.3
	"
RDEPEND="${DEPEND}
	>=virtual/jre-1.8
	"
BDEPEND="${DEPEND}
	>=virtual/jdk-1.8
	"

S="${WORKDIR}/${MY_P}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="hamcrest-core-1.3,hamcrest-library-1.3"

src_prepare() {
	default
	rm -v lib/*.jar || die
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_install() {
	java-pkg-simple_src_install
	dodoc {acknowledgements,{LEGACY_,}CODING_STYLE,NOTICE,to-do}.txt {CONTRIBUTING,README,doc/ReleaseNotes${PV}}.md
	use examples && java-pkg_doexamples src/test/java/org/junit/samples
}

src_test() {
	cd src/test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars ${JAVA_GENTOO_CLASSPATH})"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	java -cp "${CP}" -Djava.awt.headless=true org.junit.runner.JUnitCore junit.tests.AllTests || die "Running junit failed"
}
