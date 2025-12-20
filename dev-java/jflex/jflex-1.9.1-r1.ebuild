# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JFlex is a lexical analyzer generator for Java"
HOMEPAGE="https://www.jflex.de/"
SRC_URI="https://github.com/jflex-de/jflex/releases/download/v${PV}/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos"
IUSE="ant-task examples test vim-syntax"
REQUIRED_USE="test? ( ant-task )"

# jdk-11:* for bug #963787
# <dev-java/ognl-3.1.25:0 because of test failures with 3.1.25 or higher
DEPEND="
	>=virtual/jdk-11:*
	dev-java/auto-value:0
	dev-java/escapevelocity:0
	dev-java/incap:0
	>=dev-java/javacup-11b_p20160615-r2:0
	dev-java/javapoet:0
	dev-java/jsr305:0
	ant-task? ( >=dev-java/ant-1.10.15:0 )
	test? (
		dev-java/antlr-runtime:3.5
		dev-java/generics-resolver:0
		>=dev-java/guava-33.4.8:0
		dev-java/javaruntype:0
		dev-java/junit-quickcheck:0
		<dev-java/ognl-3.1.25:0
		dev-java/slf4j-simple:0
		dev-java/truth:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	ant-task? ( >=dev-java/ant-1.10.15:0 )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

DOCS=( {changelog,README}.md )
JAVA_CLASSPATH_EXTRA="auto-value,javacup,jsr305"
JAVA_MAIN_CLASS="jflex.Main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	ant
	antlr-runtime-3.5
	generics-resolver
	guava
	javaruntype
	junit-4
	junit-quickcheck
	ognl
	slf4j-simple
	truth
"

JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	# Keep pre-compiled jar for generating LexScan.java
	# It includes java_cup/runtime
	java-pkg_clean ! -path "./lib/jflex-full-${PV}.jar"

	# No need for that stuff
	rm -r src/generated || die "rm generated"

	# Providing ant-task would require dev-java/ant in dependencies.
	if use ant-task; then
		JAVA_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjar --build-only ant ant.jar)"
	else
		rm src/main/java/jflex/anttask/JFlexTask.java || die
	fi
}

jflex_compile() {
	$(java-config -J) "${@}" jflex.Main \
		-d src/main/java \
		--skel src/main/jflex/skeleton.nested \
		src/main/jflex/LexScan.flex || die
	java-pkg-simple_src_compile
}

src_compile() {
	# get processorpath
	local pp="$(java-pkg_getjar --build-only auto-value auto-value.jar)"
	pp="${pp}:$(java-pkg_getjar --build-only auto-value auto-common.jar)"
	pp="${pp}:$(java-pkg_getjars --build-only escapevelocity,guava,incap,javapoet)"

	JAVAC_ARGS="-processorpath ${pp} -s src/main/java"

	JAVACUP=$(java-pkg_getjar --build-only javacup javacup.jar)
	java -jar "${JAVACUP}" -destdir ${JAVA_SRC_DIR} -package ${PN} \
		-parser LexParse -interface src/main/cup/LexParse.cup || die

	einfo "Generate LexScan.java using pre-compiled jar"
	jflex_compile -cp "lib/jflex-full-${PV}.jar"

	einfo "Remove and re-generate LexScan.java using the freshly built jar"
	rm -v src/main/java/LexScan.java || die "rm LexScan.java"
	rm -r target || die
	jflex_compile -cp "${JAVACUP}:jflex.jar"
}

src_test() {
	local TESTS=$(find src/test/java \( -name "*Test.java" -o -name "*Quickcheck.java" \) -printf "%P\n")
	TESTS="${TESTS//.java}"
	JAVA_TEST_RUN_ONLY="${TESTS//\//.}"

	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install

	use ant-task && java-pkg_register-ant-task

	use examples && java-pkg_doexamples examples

	if use doc; then
		dodoc doc/*.pdf
		docinto html
		dodoc doc/*.{css,html} doc/COPYRIGHT
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins lib/${PN}.vim
	fi
}
