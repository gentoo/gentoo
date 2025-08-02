# Copyright 1999-2025 Gentoo Authors
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
KEYWORDS="amd64 arm64 ppc64 ~amd64-linux ~x86-linux"

# There was 1 failure:
# 1) do_not_access_non_open_methods(bsh.Java_9_Test)
# bsh.TargetError: Sourced file: inline evaluation of: ``import java.net.URL;
PROPERTIES="test_network"
RESTRICT="test"

CP_DEPEND="
	dev-java/bsf:2.3
	dev-java/jakarta-servlet-api:4
"

# restrict to max Java 25
# https://bugs.openjdk.org/browse/JDK-8359053
DEPEND="
	${CP_DEPEND}
	<=virtual/jdk-25:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=(
	CHANGES.md
	NOTICE
	README.md
)

PATCHES=( "${FILESDIR}/bsh-2.1.1-skip-tests.patch" )

JAVA_LAUNCHER_FILENAME="bsh-console"
JAVA_MAIN_CLASS="bsh.Console"
JAVA_RESOURCE_DIRS="resources/src"
JAVA_SRC_DIR=( src bsf/src engine/src )
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="tests"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./tests/test-scripts/*"

	# These classes are not in upstream jar file
	mkdir -p tests/src/bsh/engine || die
	mv {engine,tests}/src/bsh/TestBshScriptEngine.java || die
	mv {,tests/}src/bsh/JThis.java || die

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
}

src_test() {
	# tests/junitTests/src/bsh/Issue_55_Test.java:47: error: cannot find symbol
	#                 final Object scriptEngineResult = new BshScriptEngineFactory().getScriptEngine().eval(script);
	#                                                       ^
	#   symbol:   class BshScriptEngineFactory
	#   location: class Issue_55_Test
	rm tests/junitTests/src/bsh/Issue_55_Test.java || die

	# We add 3 test classes which are not covered by the default test selection of java-pkg-simple
	# We skip "OldScriptsTest" and 4 failing test classes.
	# Test failures are documeted in bug #903519.
	local JAVA_TEST_RUN_ONLY=$(find tests/junitTests/src \
		-type f \
		! -name 'OldScriptsTest.java' \
		! -name 'Class3_Test.java' \
		! -name 'Class13Test.java' \
		! -name 'Issue_7_Test.java' \
		! -name 'Issue_8_Test.java' \
		\( \
		-name "*Test.java" \
		-o -name "AnnotationsParsing.java" \
		-o -name "GoogleReports.java" \
		-o -name "Namespace_chaining.java" \
		\) -printf '%P\n')
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-exports=java.base/sun.net.www.protocol.https=ALL-UNNAMED)
	fi
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	# The eclass installs only the main launcher.
	java-pkg_dolauncher "${PN}-interpreter" --main bsh.Interpreter
}
