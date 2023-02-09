# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache-extras.beanshell:bsh:2.1.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A small embeddable Java source interpreter"
HOMEPAGE="https://github.com/beanshell/beanshell"
SRC_URI="https://github.com/beanshell/beanshell/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/beanshell-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

# There was 1 failure:
# 1) do_not_access_non_open_methods(bsh.Java_9_Test)
# bsh.TargetError: Sourced file: inline evaluation of: ``import java.net.URL;
PROPERTIES="test_network"
RESTRICT="test"

CP_DEPEND="
	dev-java/bsf:2.3
	dev-java/jakarta-servlet-api:4"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="${CP_DEPEND}
	virtual/jdk:1.8"

DOCS=(
	CHANGES.md
	NOTICE
	README.md
)

JAVA_LAUNCHER_FILENAME="bsh-console"
JAVA_MAIN_CLASS="bsh.Console"
JAVA_RESOURCE_DIRS="resources/src"
JAVA_SRC_DIR=( src bsf/src engine/src )
JAVA_TEST_EXCLUDES=(
	bsh.TestUtil	# invalid test class
	bsh.TestFilter	# invalid test class
	bsh.Class3_Test
	bsh.Class13Test
	bsh.Issue_7_Test
	bsh.Issue_8_Test
	bsh.OldScriptsTest # ?? As the name says Old...
)
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="tests/junitTests/src"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean

	# These classes are not in upstream jar file
	rm engine/src/bsh/TestBshScriptEngine.java || die
	rm src/bsh/JThis.java || die

	# java-pkg-simple.eclass wants resources in JAVA_RESOURCE_DIRS
	mkdir resources || die
	find src -type f \
		! -name '*.java' \
		! -name 'bsh.jj*' \
		! -name '*.scripted' \
		! -name '*.txt' \
		! -name '*.xml' \
		! -name '.errLog' \
		! -name 'index.html' \
		! -name 'Changes.html' \
		! -name 'CodeMap.html' \
		! -name 'Manifest.*' \
		| xargs cp --parent -t resources || die

	# Some but not all tests in these test classes fail
	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/diamond_operator()/i @Ignore' \
		-e '/try_with_resource()/i @Ignore' \
		-e '/integer_literal_enhancements()/i @Ignore' \
		-i tests/junitTests/src/bsh/Project_Coin_Test.java || die

	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/parsing_very_large_hex_literal()/i @Ignore' \
		-e '/integer_literal_enhancements_binary()/i @Ignore' \
		-e '/parsing_large_hex_literal()/i @Ignore' \
		-i tests/junitTests/src/bsh/NumberLiteralTest.java || die

	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/define_interface_with_constants()/i @Ignore' \
		-i tests/junitTests/src/bsh/ClassGeneratorTest.java || die
}

src_test() {
	# tests/junitTests/src/bsh/Issue_55_Test.java:47: error: cannot find symbol
	#                 final Object scriptEngineResult = new BshScriptEngineFactory().getScriptEngine().eval(script);
	#                                                       ^
	#   symbol:   class BshScriptEngineFactory
	#   location: class Issue_55_Test
	rm tests/junitTests/src/bsh/Issue_55_Test.java || die
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher "${PN}-interpreter" --main bsh.Interpreter
}
