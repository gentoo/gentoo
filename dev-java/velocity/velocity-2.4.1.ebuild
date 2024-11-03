# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.velocity:velocity-engine-core:2.4.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Velocity is a general purpose template engine"
HOMEPAGE="https://velocity.apache.org"
SRC_URI="https://github.com/apache/${PN}-engine/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-engine-${PV}/${PN}-engine-core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

CP_DEPEND="
	dev-java/commons-lang:3.6
	dev-java/slf4j-api:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/commons-io-2.17.0:1
	>=virtual/jdk-1.8:*
	test? (
		>=dev-db/hsqldb-2.4.1:0
		dev-java/slf4j-simple:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVACC_SLOT="7.0.13"
BDEPEND="dev-java/javacc:${JAVACC_SLOT}"

JAVA_CLASSPATH_EXTRA="commons-io-1"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXTRA_ARGS="-Dtest.compare.dir=target/test-classes -Dtest.result.dir=results"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,hsqldb,slf4j-simple"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	cp -r src/main/{,resources/org/apache/velocity/runtime}/parser || die

	sed -e "s/\${project.version}/${PV}/" \
		src/main/java-templates/org/apache/velocity/runtime/VelocityEngineVersion.java > \
		src/main/java/org/apache/velocity/runtime/VelocityEngineVersion.java || die

	sed -i \
		-e 's/\${parser.basename}/Standard/g' \
		-e 's/\${parser.package}/org.apache.velocity.runtime.parser/g' \
		-e 's/\${parser.char.asterisk}/\*/g' \
		-e 's/\${parser.char.at}/\@/g' \
		-e 's/\${parser.char.dollar}/\$/g' \
		-e 's/\${parser.char.hash}/\#/g' \
		"${S}/src/main/parser/Parser.jjt" || die

	# File "StandardParserTreeConstants.java" does not exist.  Will create one.
	# File "StandardParserVisitor.java" does not exist.  Will create one.
	# File "JJTStandardParserState.java" does not exist.  Will create one.
	"jjtree-${JAVACC_SLOT}" -GRAMMAR_ENCODING=UTF-8 \
		-JDK_VERSION=1.8 \
		-BUILD_NODE_FILES=false \
		-MULTI=true \
		-NODE_PACKAGE=org.apache.velocity.runtime.parser.node \
		-NODE_USES_PARSER=true \
		-STATIC=false \
		-OUTPUT_DIRECTORY="${JAVA_SRC_DIR}/org/apache/velocity/runtime/parser/node" \
		"${S}/src/main/parser/Parser.jjt" \
		|| die "Code generation via jjtree failed"

	"javacc-${JAVACC_SLOT}" -GRAMMAR_ENCODING=UTF-8 \
		-JDK_VERSION=1.8 \
		-STATIC=false \
		-DEBUG_PARSER=false \
		-DEBUG_LOOKAHEAD=false \
		-DEBUG_TOKEN_MANAGER=false \
		-BUILD_PARSER=true \
		-TOKEN_MANAGER_USES_PARSER=true \
		-OUTPUT_DIRECTORY="${JAVA_SRC_DIR}" \
		"${JAVA_SRC_DIR}/org/apache/velocity/runtime/parser/node/Parser.jj" \
		|| die "Parser.java code generation via javacc failed"

	# Avoid "error: duplicate class: org.apache.velocity.runtime.parser...."
	rm -v "${JAVA_SRC_DIR}/CharStream.java" || die "cannot remove 'CharStream.java'"
	rm -v "${JAVA_SRC_DIR}/ParseException.java" || die "cannot remove 'ParseException.java'"
}

src_test() {
	pushd src/test/java || die
		# DataSourceResourceLoaderTestCase.java requires configured jdbc
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*TestCase.java" \
			! -name "BaseTestCase.java" \
			! -name "DataSourceResourceLoaderTestCase.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd
	java-pkg-simple_src_test
}
