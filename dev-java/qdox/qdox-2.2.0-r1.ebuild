# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"
MAVEN_ID="com.thoughtworks.qdox:qdox:${PV}"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Parser for extracting class/interface/method definitions"
HOMEPAGE="https://github.com/paul-hammant/qdox"
SRC_URI="https://github.com/paul-hammant/qdox/archive/qdox-${PV}.tar.gz"
S="${WORKDIR}/qdox-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x64-macos"

BDEPEND="dev-java/byaccj:0"
DEPEND="
	dev-java/jflex:0
	>=dev-java/javacup-11b_p20160615-r2:0
	|| ( virtual/jdk:25 virtual/jdk:21 virtual/jdk:17 virtual/jdk:11 )
	test? (
		>=dev-java/asm-9.8-r1:=
		>=dev-java/assertj-core-3.27.6:0
		>=dev-java/mockito-5.20.0:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/qdox-2.2.0-skip-testBinaryClassesAreFound.patch" )

JAVA_AUTOMATIC_MODULE_NAME="com.thoughtworks.qdox"
JAVA_CLASSPATH_EXTRA="jflex"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm assertj-core junit-5 mockito"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default # bug #780585
	java-pkg-2_src_prepare
}

src_compile() {
	einfo "Running jflex"
	"$(java-config -J)" -cp "$(java-pkg_getjars --build-only jflex):$(java-pkg_getjars --build-only javacup)" \
		jflex.Main \
		src/grammar/lexer.flex \
		src/grammar/commentlexer.flex \
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
