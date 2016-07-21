# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN}${PV%%.*}"
MY_P="${MY_PN}-r${PV}"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simple framework to write repeatable tests"
SRC_URI="https://github.com/${PN}-team/${MY_PN}/archive/r${PV}.tar.gz -> ${MY_P}.tar.gz"
HOMEPAGE="http://junit.org/"
LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"

CDEPEND="dev-java/hamcrest-core:1.3"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="hamcrest-core-1.3"

java_prepare() {
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
