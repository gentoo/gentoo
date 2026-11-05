# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-vintage"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Mockito mock objects library core API and implementation"
HOMEPAGE="https://github.com/mockito/mockito"
SRC_URI="https://github.com/mockito/mockito/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=dev-java/apiguardian-api-1.1.2-r1:0
	>=dev-java/asm-9.10.1:0
	>=dev-java/byte-buddy-1.18.10:0
	>=dev-java/hamcrest-3.0:0
	>=dev-java/jna-5.18.1:0
	>=dev-java/jspecify-1.0.0:0
	>=dev-java/jsr305-3.0.2-r1:0
	dev-java/junit:4
	>=dev-java/objenesis-3.4:0
	>=dev-java/opentest4j-1.3.0-r1:0
	>=virtual/jdk-11:*
	>=dev-java/assertj-core-3.27.7:0
"

# virtual/jre lower than 11 would cause a compilation error:
# src/main/java/org/mockito/internal/stubbing/defaultanswers/ReturnsDeepStubs.java:57:
# error: cannot find symbol
#         final var emptyValue = ReturnsEmptyValues.returnCommonEmptyValueFor(rawType);
#               ^
#   symbol:   class var
RDEPEND=">=virtual/jre-11:*"

PATCHES=( "${FILESDIR}"/mockito-5.24.0-skipFailingTests.patch )

JAVA_CLASSPATH_EXTRA="apiguardian-api asm byte-buddy hamcrest jna jspecify jsr305 objenesis opentest4j"
JAVA_TEST_SRC_DIR="mockito-core/src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	# prevent assertj-core and junit:{4,5} to pull hamcrest-core on classpath
	JAVA_GENTOO_CLASSPATH_EXTRA=":$(java-pkg_getjars --build-only \
		assertj-core,junit-4,junit-5)"

	# dev-java/byte-buddy is built from byte-buddy-dep without shaded stuff.
	sed \
		-i -e 's:net.bytebuddy.jar.asm:org.objectweb.asm:' \
		mockito-core/src/main/java/org/mockito/internal/creation/bytebuddy/MockMethodAdvice.java \
		mockito-core/src/main/java/org/mockito/internal/creation/bytebuddy/InlineBytecodeGenerator.java \
		mockito-core/src/main/java/org/mockito/internal/creation/bytebuddy/ClinitSuppressionTransformer.java \
		mockito-core/src/test/java/org/mockito/internal/creation/bytebuddy/ClinitSuppressionTransformerTest.java
}

src_compile() {
	JAVA_JAR_FILENAME="mockito-core.jar"
	JAVA_SRC_DIR="mockito-core/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":mockito-core.jar"
	# save MockMethodDispatcher.class for compiling test-classes
	mkdir -p dispatcher/org/mockito/internal/creation/bytebuddy/inject || die
	cp target/classes/org/mockito/internal/creation/bytebuddy/inject/MockMethodDispatcher.class \
		dispatcher/org/mockito/internal/creation/bytebuddy/inject || die
	# rename according to mockito-core/build.gradle.kts
	mv target/classes/org/mockito/internal/creation/bytebuddy/inject/MockMethodDispatcher.class \
		target/classes/org/mockito/internal/creation/bytebuddy/inject-MockMethodDispatcher.raw || die
#	rm mockito-core.jar || die
	jar cf mockito-core.jar -C target/classes . || die "refresh core.jar"

	rm -r target/classes || die "clean classes"
	JAVA_JAR_FILENAME="mockito-junit-jupiter.jar"
	JAVA_SRC_DIR="mockito-extensions/mockito-junit-jupiter/src/main/java"
	java-pkg-simple_src_compile
}

src_test() {
	find mockito-core/src/testFixtures/java -type f -name '*.java' > testFixtures.lst || die
	ejavac -d testFixtures @testFixtures.lst \
		-cp mockito-core.jar:"$(java-pkg_getjars --with-dependencies \
		--build-only assertj-core,junit-4,objenesis)"

	JAVA_GENTOO_CLASSPATH_EXTRA+=":testFixtures:dispatcher"

	# TODO: MockMethodDispatcher.class is needed on classpath
	# for compiling InlineDelegateByteBuddyMockMakerTest.java
	# but must not be there when running the tests.

	JAVA_TEST_RUN_ONLY=( org.mockito.MockitoClearTest ) # fails if not run separately
	junit5_src_test
	JAVA_TEST_RUN_ONLY=()
	JAVA_TEST_EXCLUDES=( org.mockito.MockitoClearTest )
	junit5_src_test
}

src_install() {
	JAVA_JAR_FILENAME="mockito-core.jar"
	java-pkg-simple_src_install
	java-pkg_dojar mockito-junit-jupiter.jar
}
