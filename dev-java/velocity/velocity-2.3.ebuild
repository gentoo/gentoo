# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/apache/velocity-engine/archive/refs/tags/2.3.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild velocity-2.3.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.velocity:velocity-engine-core:2.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Velocity is a general purpose template engine."
HOMEPAGE="https://velocity.apache.org"
SRC_URI="https://github.com/apache/${PN}-engine/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# commons-io:commons-io:2.8.0 -> >=dev-java/commons-io-2.8.0:1
# org.apache.commons:commons-lang3:3.11 -> >=dev-java/commons-lang-3.11:3.6
# org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.30:0

CDEPEND="
	>=dev-java/commons-io-2.8.0:1
	>=dev-java/commons-lang-3.11:3.6
	>=dev-java/slf4j-api-1.7.30:0
"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.hsqldb:hsqldb:2.5.1 -> !!!groupId-not-found!!!
# test? org.slf4j:slf4j-simple:1.7.30 -> >=dev-java/slf4j-simple-1.7.30:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		dev-db/hsqldb:0
		>=dev-java/slf4j-simple-1.7.30:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

BDEPEND="
	dev-java/javacc:0
"

S="${WORKDIR}/${PN}-engine-${PV}/${PN}-engine-core"

JAVA_GENTOO_CLASSPATH="commons-io-1,commons-lang-3.6,slf4j-api"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,hsqldb,slf4j-simple"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	# org.junit.runners.model.InvalidTestClassError: Invalid test class, No runnable methods
	"org.apache.velocity.test.RenderVelocityTemplateTest"
	"org.apache.velocity.test.provider.TestNumber"
	"org.apache.velocity.test.provider.TestProvider"
	"org.apache.velocity.test.sql.TestDataSource"
	"org.apache.velocity.test.misc.TestContext"

	# java.lang.IllegalArgumentException: Test class can only have one constructor
	"org.apache.velocity.test.misc.TestLogger"

	# junit.framework.AssertionFailedError: Class org.apache.velocity.test.sql.BaseSQLTest has no public constructor TestCase(String name) or TestCase()
	"org.apache.velocity.test.sql.BaseSQLTest"

	# requires configured jdbc
	# junit.framework.AssertionFailedError: Exception in constructor: testSimpleTemplate (java.lang.NullPointerException
	# junit.framework.AssertionFailedError: Exception in constructor: testNullTimestamp (java.lang.NullPointerException
	# junit.framework.AssertionFailedError: Exception in constructor: testMacroInvocation (java.lang.NullPointerException
	# junit.framework.AssertionFailedError: Exception in constructor: testRenderTool (java.lang.NullPointerException
	"org.apache.velocity.test.sql.DataSourceResourceLoaderTestCase"
)

src_prepare() {
	default

	cp -v "${JAVA_SRC_DIR}-templates/org/apache/velocity/runtime/VelocityEngineVersion.java" \
		"${JAVA_SRC_DIR}/org/apache/velocity/runtime/VelocityEngineVersion.java" || die

	sed -i "s/\${project.version}/${PV}/g" \
		"${JAVA_SRC_DIR}/org/apache/velocity/runtime/VelocityEngineVersion.java" || die

	# fix paths for tests
	sed -i \
		-e "s%System.getProperty(\"test.compare.dir\")%\"${S}/target/test-classes\"%g" \
		-e "s%System.getProperty(\"test.result.dir\")%\"${S}/results\"%g" \
		"${JAVA_TEST_SRC_DIR}/org/apache/velocity/test/TemplateTestBase.java" || die

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
	jjtree -GRAMMAR_ENCODING=UTF-8 \
		-JDK_VERSION=1.8 \
		-BUILD_NODE_FILES=false \
		-MULTI=true \
		-NODE_PACKAGE=org.apache.velocity.runtime.parser.node \
		-NODE_USES_PARSER=true \
		-STATIC=false \
		-OUTPUT_DIRECTORY="${JAVA_SRC_DIR}/org/apache/velocity/runtime/parser/node" \
		"${S}/src/main/parser/Parser.jjt" \
		|| die "Code generation via jjtree failed"

	javacc -GRAMMAR_ENCODING=UTF-8 \
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
