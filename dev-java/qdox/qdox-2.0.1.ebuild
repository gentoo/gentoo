# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.thoughtworks.qdox:qdox:2.0.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Parser for extracting class/interface/method definitions"
HOMEPAGE="https://github.com/paul-hammant/qdox"
SRC_URI="https://github.com/paul-hammant/qdox/archive/qdox-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~ppc-macos ~x64-macos"

DEPEND="
	dev-java/jflex:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/junit:4
		dev-java/mockito:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="dev-java/byaccj:0"

S="${WORKDIR}/qdox-${P}"

JAVA_AUTOMATIC_MODULE_NAME="com.thoughtworks.qdox"
JAVA_SRC_DIR="src/main/java"
JAVA_CLASSPATH_EXTRA="jflex"

JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_GENTOO_CLASSPATH="
	junit-4
	mockito
"

src_compile() {
	einfo "Running jflex"
	jflex src/grammar/lexer.flex src/grammar/commentlexer.flex \
		-d src/main/java/com/thoughtworks/qdox/parser/impl || die

	einfo "Running byaccj for DefaultJavaCommentParser"
	byaccj -v \
		-Jnorun \
		-Jnoconstruct \
		-Jclass=DefaultJavaCommentParser \
		-Jpackage=com.thoughtworks.qdox.parser.impl \
		src/grammar/commentparser.y || die

	einfo "Running byaccj for Parser"
	byaccj -v \
		-Jnorun \
		-Jnoconstruct \
		-Jclass=Parser \
		-Jimplements=CommentHandler \
		-Jsemantic=Value \
		-Jpackage=com.thoughtworks.qdox.parser.impl \
		src/grammar/parser.y || die

	mv Parser.java src/main/java/com/thoughtworks/qdox/parser/impl/ || die
	mv DefaultJavaCommentParser.java src/main/java/com/thoughtworks/qdox/parser/impl/ || die
	mv DefaultJavaCommentParserVal.java src/main/java/com/thoughtworks/qdox/parser/impl/ || die

	einfo "Running java-pkg-simple_src_compile"
	java-pkg-simple_src_compile
}

src_test() {
	# Too many tests fail with Java 17.
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17 ; then
		einfo "Tests only for Java < 17"
	else
		einfo "Running tests"
		pushd src/test/java || die
			local JAVA_TEST_RUN_ONLY=$(find * \
				\( -wholename "**/*Test.java" \
				-o -name 'TestMultipleLevelGenericInheritance.java' \)\
				! -name "ClassLibraryBuilderTest.java" \
				! -name "JavaClassTest.java" \
				! -name "JavaConstructorTest.java" \
				! -name "JavaFieldTest.java" \
				! -name "JavaMethodTest.java" \
				! -name "JavaPackageTest.java" \
				! -name "JavaParameterTest.java" \
				! -name "JavaSourceTest.java" \
				! -name "JavaTypeTest.java" \
				! -name "AbstractDocletTagTest.java" \
				)
		popd
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
		java-pkg-simple_src_test
	fi
}
