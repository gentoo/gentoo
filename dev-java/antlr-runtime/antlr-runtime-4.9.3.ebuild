# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.antlr:antlr4-runtime:4.9.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN%-runtime}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ANTLR 4 Runtime"
HOMEPAGE="https://www.antlr.org/"
SRC_URI="https://github.com/antlr/antlr4/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		~dev-java/antlr-tool-${PV}:${SLOT}
		dev-java/jol-core:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${MY_PN}4-${PV}"

JAVA_SRC_DIR="runtime/Java/src"

JAVA_TEST_GENTOO_CLASSPATH="
	junit-4
	antlr-tool-${SLOT}
	jol-core
"
JAVA_TEST_SRC_DIR=(
	runtime-testsuite/test
	runtime-testsuite/annotations
)
JAVA_TEST_RESOURCE_DIRS=(
	runtime-testsuite/resources
)

src_prepare() {
	java-pkg_clean
	eapply "${FILESDIR}/${PV}-test-fixes.patch"
	java-pkg-2_src_prepare
}

src_test() {
	# Build classpath for tests
	# The JAR created during src_compile must appear in the classpath *before*
	# any dependencies to ensure that *it* is the JAR being tested; otherwise,
	# because the test suite depends on antlr-tool, which depends on this
	# package, the copy of this package's JAR installed on the system would be
	# tested instead when it appears earlier in the classpath, which might
	# cause test failures when the version being built differs from the version
	# already installed on the system, like https://bugs.gentoo.org/834138
	local CP="${S}/${JAVA_JAR_FILENAME}"
	local test_dep res_dir
	for test_dep in ${JAVA_TEST_GENTOO_CLASSPATH}; do
		CP+=":$(java-pkg_getjars --with-dependencies "${test_dep}")"
	done
	for res_dir in "${JAVA_TEST_RESOURCE_DIRS[@]}"; do
		CP+=":${res_dir}"
	done

	pushd "${JAVA_TEST_SRC_DIR[0]}" > /dev/null ||
		die "Failed to enter test source directory for ${PN}"

	einfo "Removing tests for non-Java runtimes ..."
	find org/antlr/v4/test/runtime/* -maxdepth 0 -type d \
		-not -name category -not -name descriptors -not -name java \
		-exec einfo "  {}" \; -exec rm -r "{}" + ||
		die "Failed to remove tests for non-Java runtimes"

	einfo "Generating ANTLR 4 parsers for tests ..."
	local java_exe="$(java-config -J)"
	local g4_files=( $(find * -name "*.g4") )
	local file
	for file in "${g4_files[@]}"; do
		local java_pkg="${file%/*.g4}"
		java_pkg="${java_pkg//\//.}"
		"${java_exe}" -cp "${CP}" org.antlr.v4.Tool \
			-visitor -package "${java_pkg}" "${file}" ||
			die "Failed to generate ANTLR 4 parser from ${file}"
	done

	# Create a list of tests to run
	# https://github.com/antlr/antlr4/blob/4.9.3/runtime-testsuite/pom.xml#L100
	# Excluding classes with "No runnable methods"
	local TESTS=$(find * -type f -name "Test*.java" \
		-not -name "TestContext.java" \
		-not -name "TestOutputReading.java"
	)
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	popd > /dev/null || die "Failed to leave test source directory for ${PN}"

	local classes="target/classes"

	# Compile the annotation processor of @CommentHasStringValue
	# before the test sources (requires tools.jar)
	ejavac -d "${classes}" -cp "${CP}:$(java-config -t)" \
		$(find runtime-testsuite/{annotations,processors} -name "*.java")
	local processor_cp="${classes}:runtime-testsuite/processors/resources"

	# Compile Java test sources, and process @CommentHasStringValue
	# annotations at the same time
	local javac_extra_args=()
	if ver_test "$(java-config -g PROVIDES_VERSION)" -ge 17; then
		javac_extra_args+=(
			-J--add-opens=jdk.compiler/com.sun.tools.javac.{main,model,tree,util}=ALL-UNNAMED
		)
	fi
	ejavac -d "${classes}" -cp "${CP}:${processor_cp}" \
		"${javac_extra_args[@]}" \
		$(find "${JAVA_TEST_SRC_DIR[@]}" -name "*.java")

	ejunit4 -classpath "${classes}:${CP}" ${TESTS}
}
