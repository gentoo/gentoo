# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Artifact ID for antlr-tool is 'antlr4'
# https://github.com/antlr/antlr4/blob/4.9.3/tool/pom.xml#L14
MAVEN_ID="org.antlr:antlr4:4.9.3"

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN%-tool}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The ANTLR 4 grammar compiler"
HOMEPAGE="https://www.antlr.org/"
# Maven Central sources JAR for tool/src/org/antlr/v4/unicode/UnicodeData.java,
# which requires string-template-maven-plugin to generate; tarball for the rest
SRC_URI="
	https://github.com/antlr/antlr4/archive/${PV}.tar.gz -> ${MY_P}.tar.gz
	https://repo1.maven.org/maven2/org/antlr/antlr4/${PV}/antlr4-${PV}-sources.jar -> ${P}-sources.jar
"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

CP_DEPEND="
	~dev-java/antlr-runtime-${PV}:${SLOT}
	dev-java/antlr-runtime:3.5
	dev-java/jakarta-json-api:1
	>=dev-java/icu4j-74.2-r1:0
	dev-java/stringtemplate:4
	dev-java/treelayout:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	dev-java/antlr-tool:3.5
	test? (
		dev-java/jol-core:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/${MY_PN}4-${PV}"

JAVA_SRC_DIR=(
	tool/src
	../src/org # For UnicodeData.java
)
JAVA_RESOURCE_DIRS=( tool/resources )

JAVA_TEST_GENTOO_CLASSPATH="junit-4,jol-core"
JAVA_TEST_SRC_DIR=(
	tool-testsuite/test
	# The runtime test suite is used as a library for tool test suite
	runtime-testsuite/{annotations,test}
)
JAVA_TEST_RESOURCE_DIRS=(
	# Some resources are mixed with test source files
	"${JAVA_TEST_SRC_DIR[0]}"
)

pkg_setup() {
	java-pkg-2_pkg_setup
	MY_JAVA="$(java-config -J)"
}

src_prepare() {
	java-pkg_clean
	eapply "${FILESDIR}/${PV}-test-fixes.patch"
	java-pkg-2_src_prepare
}

src_compile() {
	einfo "Generating ANTLR 3 parsers"
	"${MY_JAVA}" -cp "$(java-pkg_getjars \
		--build-only --with-dependencies antlr-tool-3.5)" \
		org.antlr.Tool $(find "${JAVA_SRC_DIR[@]}" -name "*.g") ||
		die "Failed to generate ANTLR 3 parsers"
	java-pkg-simple_src_compile
}

src_test() {
	# Build classpath for tests
	local test_deps=(
		"${JAVA_TEST_GENTOO_CLASSPATH}"
		antlr-runtime-${SLOT}
		antlr-runtime-3.5
		jakarta-json-api-1
		icu4j
		stringtemplate-4
		treelayout
	)
	local CP="${S}/${JAVA_JAR_FILENAME}"
	for test_dep in "${test_deps[@]}"; do
		CP+=":$(java-pkg_getjars --build-only --with-dependencies "${test_dep}")"
	done
	for res_dir in "${JAVA_TEST_RESOURCE_DIRS[@]}"; do
		CP+=":${res_dir}"
	done

	einfo "Generating ANTLR 4 parsers for tests"
	pushd runtime-testsuite/test > /dev/null ||
		die "Failed to enter runtime test source directory"
	g4_files=( $(find * -name "*.g4") )
	for file in "${g4_files[@]}"; do
		java_pkg="${file%/*.g4}"
		java_pkg="${java_pkg//\//.}"
		"${MY_JAVA}" -cp "${CP}" org.antlr.v4.Tool \
			-visitor -package "${java_pkg}" "${file}" ||
			die "Failed to generate ANTLR 4 parser from ${file}"
	done
	popd > /dev/null || die "Failed to leave runtime test source directory"

	# Compile Java test sources
	local classes="target/classes"
	ejavac -d "${classes}" -cp "${CP}" \
		$(find "${JAVA_TEST_SRC_DIR[@]}" -name "*.java")

	# Create a list of tests to run
	pushd "${JAVA_TEST_SRC_DIR[0]}" > /dev/null ||
		die "Failed to enter test source directory for ${PN}"
	local TESTS=$(find * -type f \
		\( -name "Test*.java" -o -name "*Test.java" \) \
		-not -name "BaseJavaToolTest.java" # No runnable methods
	)
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"
	popd > /dev/null || die "Failed to leave test source directory for ${PN}"

	ejunit4 -classpath "${classes}:${CP}" ${TESTS}
}
