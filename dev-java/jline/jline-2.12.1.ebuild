# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java library for handling console input"
HOMEPAGE="https://github.com/jline/jline2"
SRC_URI="https://github.com/jline/jline2/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE="test"

CDEPEND="dev-java/jansi:1.11
	dev-java/jansi-native:0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5
	test? ( dev-java/junit:4 )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

S="${WORKDIR}/${PN}2-${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="jansi-1.11,jansi-native"

java_prepare() {
	# Easier to use java-pkg-simple.
	rm -v pom.xml || die

	# Don't forget the resources!
	mkdir -p target/classes || die
	cp -r src/main/resources/* target/classes || die
}

src_install() {
	java-pkg-simple_src_install

	dodoc {CHANGELOG,README}.md
}

src_test() {
	cd src/test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find * -name "*Test.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
