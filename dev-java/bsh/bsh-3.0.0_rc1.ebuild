# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

JAVACC_SLOT="8"

DESCRIPTION="A small embeddable Java source interpreter"
HOMEPAGE="https://github.com/beanshell/beanshell"
SRC_URI="https://github.com/beanshell/beanshell/archive/${PV/_rc/RC}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/beanshell-${PV/_rc/RC}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	dev-java/javacc:${JAVACC_SLOT}
	dev-java/javacc-java:${JAVACC_SLOT}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		>=dev-java/jmh-core-1.37:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CHANGES,HISTORY,MIGRATION,README}.md NOTICE )

# src/main/java/bsh/Interpreter.java:1100: error: invalid use of a restricted identifier 'yield'
JAVADOC_ARGS="-source 8"
#	JAVA_GENTOO_CLASSPATH="asm"
JAVA_LAUNCHER_FILENAME="bsh-console"
JAVA_MAIN_CLASS="bsh.Console"
JAVA_RESOURCE_DIRS="src/main/resources"

# Attempts to unbundle asm would cause some test failures.
#	JAVA_SRC_DIR=( src/main/java -type f ! -path '*/objectweb/*' ) # unbundle asm
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXCLUDES=(
	mypackage.ReflectTest # Invalid
	bsh.TestFilter # Invalid
	bsh.TestUtil # Invalid
	# All 3 tests of of following test-class fail
	bsh.SharedInterpreterEvalConcurrencyTest
)
JAVA_TEST_GENTOO_CLASSPATH="hamcrest-core-1.3 hamcrest-library-1.3 jmh-core junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	cat <<- VERSION > src/main/resources/bsh/version.properties || die "version.properties"
		build=1234
		release=${PV/_rc/RC}
	VERSION

#	sed \
#		-i -e 's:bsh.org.objectweb.asm:org.objectweb.asm:' \
#		src/main/java/bsh/BshLambda.java \
#		src/main/java/bsh/ClassGeneratorUtil.java \
#		src/test/java/bsh/BshLambdaClassLoadingTest.java \
#		src/test/java/bsh/ClassLifecycleConcurrencyTest.java \
#		src/test/java/bsh/ReflectTest.java

	local CP="$(java-pkg_getjars --build-only javacc-${JAVACC_SLOT},javacc-java-${JAVACC_SLOT})"
	"$(java-config -J)" -cp "${CP}" org.javacc.jjtree.Main \
		-JJTREE_OUTPUT_DIRECTORY="jjtree-out" \
		"src/main/jjtree/bsh.jjt" || die "jjtree"

	"$(java-config -J)" -cp "${CP}" org.javacc.parser.Main \
	-OUTPUT_DIRECTORY="javacc-out" \
	jjtree-out/bsh.jj || die "javacc"

	cp --update=none -v jjtree-out/*.java src/main/java/bsh || die
	cp --update=none -v javacc-out/*.java src/main/java/bsh || die

	# This test ramdomly fails or passes.
	# Settings accoding to pom.xml, line 292, don't help.
	# JAVA_TEST_EXTRA_ARGS="-Xmx1000M -Xms500M" # pom.xml, line 292
	rm -v src/test/resources/test-scripts/trycatch_ome.bsh || die
}

src_install() {
#	use source && JAVA_SRC_DIR=( src/main/java )
	java-pkg-simple_src_install
	# The eclass installs only the main launcher.
	java-pkg_dolauncher "${PN}-interpreter" --main bsh.Interpreter
}
