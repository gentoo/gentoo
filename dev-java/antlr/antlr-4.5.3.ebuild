# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A parser generator for many languages"
HOMEPAGE="http://www.antlr.org/"
SRC_URI="https://github.com/${PN}/${PN}4/archive/${PV}.tar.gz -> ${P}.tar.gz
	http://www.antlr.org/download/${P}-complete.jar" # Prebuilt version needed.
LICENSE="BSD"
SLOT="4"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

CDEPEND="dev-java/antlr:3.5
	dev-java/stringtemplate:4
	dev-java/treelayout:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	test? (
		dev-java/hamcrest-core:1.3
		dev-java/junit:4
	)"

S="${WORKDIR}/${PN}4-${PV}"
JAVA_GENTOO_CLASSPATH="stringtemplate-4,treelayout"

src_unpack() {
	unpack ${P}.tar.gz
}

java_prepare() {
	java-pkg_clean
}

src_configure() {
	# TODO: Make java-config accept a jar@package query.
	JAVA_GENTOO_CLASSPATH_EXTRA="${S}/${PN}-runtime.jar:$(java-pkg_getjar antlr-3.5 antlr-runtime.jar)"
}

src_compile() {
	cd "${S}/runtime/Java/src"
	local G PKG

	for G in $(find * -name "*.g4"); do
		PKG="${G%/*}"
		PKG="${PKG//\//.}"
		java -jar "${DISTDIR}/${P}-complete.jar" -package "${PKG}" "${G}" || die
	done

	JAVA_JAR_FILENAME="${S}/${PN}-runtime.jar" JAVA_PKG_IUSE="doc" java-pkg-simple_src_compile

	cd "${S}/tool/src"
	antlr3.5 $(find -name "*.g") || die
	JAVA_JAR_FILENAME="${S}/${PN}-tool.jar" java-pkg-simple_src_compile
	java-pkg_addres "${S}/${PN}-tool.jar" ../resources
}

src_install() {
	java-pkg_dojar ${PN}-{runtime,tool}.jar
	java-pkg_dolauncher ${PN}${SLOT} --main org.antlr.v4.Tool
	use doc && java-pkg_dojavadoc runtime/Java/src/target/api
	use source && java-pkg_dosrc runtime/Java/src/org tool/src/org
}

junit_suite() {
	cd "${S}/$1-testsuite/test" || die
	local CP=".:${S}/runtime-testsuite/test:${S}/${PN}-tool.jar:$(java-pkg_getjars hamcrest-core-1.3,junit-4,${JAVA_GENTOO_CLASSPATH}):${JAVA_GENTOO_CLASSPATH_EXTRA}"

	local TESTS=$(find ${2:-*} -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" $(find ${2:-*} -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}

src_test() {
	# Only run Java runtime tests as we haven't built other languages.
	junit_suite runtime org/antlr/v4/test/runtime/java
	junit_suite tool
}
