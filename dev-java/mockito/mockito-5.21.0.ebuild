# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

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
	>=dev-java/asm-9.9.1:0
	>=dev-java/byte-buddy-1.18.2:0
	>=dev-java/hamcrest-3.0:0
	>=dev-java/jna-5.18.1:0
	>=dev-java/jsr305-3.0.2-r1:0
	>=dev-java/junit-4.13.2_p20240222:4
	dev-java/junit:5
	>=dev-java/objenesis-3.4:0
	>=dev-java/opentest4j-1.3.0-r1:0
	>=virtual/jdk-11:*
	test? ( >=dev-java/assertj-core-3.27.6:0 )
"

# virtual/jre lower than 11 would cause a compilation error:
# src/main/java/org/mockito/internal/stubbing/defaultanswers/ReturnsDeepStubs.java:57:
# error: cannot find symbol
#         final var emptyValue = ReturnsEmptyValues.returnCommonEmptyValueFor(rawType);
#               ^
#   symbol:   class var
RDEPEND=">=virtual/jre-11:*"

JAVA_CLASSPATH_EXTRA="apiguardian-api asm byte-buddy hamcrest jna jsr305 objenesis opentest4j"
JAVA_TEST_SRC_DIR="mockito-core/src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	# prevent junit:{4,5} to pull hamcrest-core on classpath
	JAVA_GENTOO_CLASSPATH_EXTRA=":$(java-pkg_getjars --build-only junit-4)"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjars --build-only junit-5)"

	# dev-java/byte-buddy is built from byte-buddy-dep without shaded stuff.
	sed \
		-e 's:net.bytebuddy.jar.asm:org.objectweb.asm:' \
		-i mockito-core/src/main/java/org/mockito/internal/creation/bytebuddy/MockMethodAdvice.java \
		-i mockito-core/src/main/java/org/mockito/internal/creation/bytebuddy/InlineBytecodeGenerator.java || die
}

src_compile() {
	JAVA_JAR_FILENAME="mockito-core.jar"
	JAVA_SRC_DIR="mockito-core/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":mockito-core.jar"
	# whatever '.raw' is good for, upstream does it and we follow (and re-create the jar).
	mv target/classes/org/mockito/internal/creation/bytebuddy/inject/MockMethodDispatcher.class \
		target/classes/org/mockito/internal/creation/bytebuddy/inject-MockMethodDispatcher.raw || die
	rm mockito-core.jar || die "remove core.jar"
	jar cf mockito-core.jar -C target/classes . || die "refresh core.jar"

	rm -r target/classes || die "clean classes"
	JAVA_JAR_FILENAME="mockito-junit-jupiter.jar"
	JAVA_SRC_DIR="mockito-extensions/mockito-junit-jupiter/src/main/java"
	java-pkg-simple_src_compile
}

src_test() {
	# mockito-core/src/test/java/org/mockito/internal/creation/bytebuddy/InlineDelegateByteBuddyMockMakerTest.java:347: error: cannot access MockMethodDispatcher
	#         throwable = MockMethodAdvice.removeRecursiveCalls(throwable, SampleInterface.class);
	#                                     ^
	#   class file for org.mockito.internal.creation.bytebuddy.inject.MockMethodDispatcher not found
	rm -v mockito-core/src/test/java/org/mockito/internal/creation/bytebuddy/InlineDelegateByteBuddyMockMakerTest.java || die
	rm -v mockito-core/src/test/java/org/mockito/internal/creation/bytebuddy/sample/DifferentPackage.java || die

	# assertj-core --with-dependencies seems to pull another hamcrest into classpath.
	JAVA_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjars --build-only assertj-core)"
	rm -r target/classes || die "clean classes"
	JAVA_JAR_FILENAME="testFixtures.jar"
	JAVA_SRC_DIR="mockito-core/src/testFixtures/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":testFixtures.jar"
	junit5_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar mockito-core.jar
}
