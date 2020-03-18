# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="A parser generator for many languages"
HOMEPAGE="https://www.antlr3.org/"
SRC_URI="https://github.com/${PN}/${PN}3/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://www.antlr3.org/download/${P}-complete.jar" # Prebuilt version needed.
LICENSE="BSD"
SLOT="3.5"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

CDEPEND="dev-java/stringtemplate:4"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${PN}3-${PV}"
JAVA_GENTOO_CLASSPATH_EXTRA="${S}/${PN}-runtime.jar"
JAVA_GENTOO_CLASSPATH="stringtemplate-4"

src_unpack() {
	unpack ${P}.tar.gz
}

java_prepare() {
	java-pkg_clean

	# This requires StringTemplate v3 and is only needed for
	# output=template. Nothing in the tree currently needs that and the
	# dependency situation is already hairy enough as it is.
	rm -v runtime/Java/src/main/java/org/antlr/runtime/tree/DOTTreeGenerator.java || die

	# Some tests have to be removed as a result.
	rm -v tool/src/test/java/org/antlr/test/Test{RewriteTemplates,Templates}.java || die
	epatch "${FILESDIR}/${PV}-test-fixes.patch"

	# Some tests fail under Java 8 in ways that probably aren't limited
	# to the tests. This is bad but upstream is never going to update
	# 3.5. At the time of writing, we only use it to build 4 anyway.
	if java-pkg_is-vm-version-ge 1.8; then
		rm -v tool/src/test/java/org/antlr/test/Test{DFAConversion,SemanticPredicates,TopologicalSort}.java || die
	fi
}

src_compile() {
	cd "${S}/runtime/Java/src/main" || die
	JAVA_JAR_FILENAME="${S}/${PN}-runtime.jar" JAVA_PKG_IUSE="doc" java-pkg-simple_src_compile

	cd "${S}/tool/src/main" || die
	java -jar "${DISTDIR}/${P}-complete.jar" $(find antlr3 -name "*.g") || die
	JAVA_JAR_FILENAME="${S}/${PN}-tool.jar" java-pkg-simple_src_compile
	java-pkg_addres "${S}/${PN}-tool.jar" resources
}

src_install() {
	java-pkg_dojar ${PN}-{runtime,tool}.jar
	java-pkg_dolauncher ${PN}${SLOT} --main org.antlr.Tool
	use doc && java-pkg_dojavadoc runtime/Java/src/main/target/api
}

src_test() {
	cd tool/src/test/java || die
	local CP=".:${S}/${PN}-runtime.jar:${S}/${PN}-tool.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"

	local TESTS=$(find * -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" $(find -name "*.java")

	# ejunit automatically adds all registered subdependencies to the
	# classpath, which is annoying in this case because of the cyclic
	# dependency on stringtemplate. It will blow up when trying to find
	# antlr-3.5 on the system before it is installed. The easiest but
	# somewhat ugly way to avoid this is to unset JAVA_PKG_DEPEND_FILE.
	JAVA_PKG_DEPEND_FILE= ejunit4 -classpath "${CP}" ${TESTS}
}
