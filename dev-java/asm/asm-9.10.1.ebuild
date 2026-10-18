# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

# Avoid circular dependency
JAVA_DISABLE_DEPEND_ON_JAVA_DEP_CHECK="true"

inherit java-pkg-2 java-pkg-simple junit5

MY_P="ASM_${PV//./_}"

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="https://asm.ow2.io"
SRC_URI="https://gitlab.ow2.org/asm/asm/-/archive/${MY_P}/asm-${MY_P}.tar.bz2"
S="${WORKDIR}/asm-${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos"

DEPEND="
	>=virtual/jdk-11:*
	test? (
		>=dev-java/janino-3.1.9:0
		dev-java/junit:5[-vintage]
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}"/asm-9.10-gentoo.patch )

ASM_MODULES=( "asm" "asm-tree" "asm-analysis" "asm-commons" "asm-util" )
JAVADOC_SRC_DIRS=( asm{-analysis,-commons,,-tree,-util}/src/main/java )
JAVA_TEST_GENTOO_CLASSPATH="janino junit-5 opentest4j"
JAVA_TEST_RESOURCE_DIRS=( asm{-analysis,-commons,,-tree,-util}/src/test/resources )

# The junit:5 version is too old, compilation of LambdaRemapTest.java fails with:
# asm-commons/src/test/java/org/objectweb/asm/commons/LambdaRemapTest.java:9: error: cannot find symbol
# import org.junit.jupiter.params.Parameter;
#                                ^
#   symbol:   class Parameter

JAVA_TEST_SRC_DIR=( asm{-analysis,-commons,,-test,-tree,-util}/src/test/java \
	! -name LambdaRemapTest.java )

src_compile() {
	local module
	for module in "${ASM_MODULES[@]}"; do
		einfo "Compiling ${module}"
		JAVA_GENTOO_CLASSPATH_EXTRA+=":${module}.jar"
		JAVA_INTERMEDIATE_JAR_NAME="org.objectweb.${module/-/.}"
		JAVA_JAR_FILENAME="${module}.jar"
		JAVA_MODULE_INFO_OUT="${module}/src/main"
		JAVA_MODULE_INFO_RELEASE=9
		JAVA_SRC_DIR="${module}/src/main/java"
		java-pkg-simple_src_compile
		rm -r target || die
	done

	# upstream generates module-info into root of the jars
	for module in "${ASM_MODULES[@]}"; do
		einfo "Adjust mudule-info in ${module}"
		mkdir target || die
		pushd target >/dev/null || die
		jar xf ../${module}.jar || die
		rm -v ../${module}.jar || die
		mv {META-INF/versions/9/,}module-info.class || die
		rm -rv META-INF || die
		popd >/dev/null || die
		jar cf ${module}.jar -C target . || die
		rm -r target || die
	done

	use doc && ejavadoc
}

src_test() {
	JAVAC_ARGS="-g"
	JAVA_CLASSPATH_EXTRA="junit-5"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":asm-test.jar"
	JAVA_JAR_FILENAME="asm-test.jar"
	JAVA_RESOURCE_DIRS=( asm-test/src/main/resources )
	JAVA_SRC_DIR=( asm-test/src/main/java )
	java-pkg-simple_src_compile
	junit5_src_test
}

src_install() {
	JAVA_JAR_FILENAME="asm.jar"
	java-pkg-simple_src_install
	local module
	for module in asm-{analysis,commons,tree,util}; do
		java-pkg_dojar ${module}.jar
		if use source; then
			java-pkg_dosrc "${module}/src/main/java/*"
		fi
	done
}
