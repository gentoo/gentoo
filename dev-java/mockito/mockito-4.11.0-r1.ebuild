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
SLOT="4"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="
	dev-java/asm:0
	dev-java/byte-buddy:0
	dev-java/objenesis:0
"

DEPEND="
	dev-java/junit:4
	dev-java/opentest4j:0
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? ( dev-java/assertj-core:0 )
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

PATCHES=(
	"${FILESDIR}"/mockito-4.11.0-CloningParameterTest.patch
	"${FILESDIR}"/mockito-4.11.0-AbstractByteBuddyMockMakerTest.patch
	"${FILESDIR}"/mockito-4.11.0-UnusedStubbingsTest.patch
)

JAVA_AUTOMATIC_MODULE_NAME="org.mockito"
JAVA_CLASSPATH_EXTRA="junit-4 opentest4j"
JAVA_GENTOO_CLASSPATH_EXTRA=":dispatcher:mockito-core.jar"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="assertj-core"
JAVA_TEST_SRC_DIR="src/test/java"

JAVA_TEST_EXCLUDES=(
	org.mockitousage.stubbing.StubbingWithBadThrowablesTest # only 1 test
	org.mockito.internal.stubbing.defaultanswers.ReturnsDeepStubsConcurrentTest # only 1 test
)

src_prepare() {
	java-pkg-2_src_prepare
	# dev-java/byte-buddy is built from byte-buddy-dep without shaded stuff.
	sed \
		-e 's:net.bytebuddy.jar.asm:org.objectweb.asm:' \
		-i src/main/java/org/mockito/internal/creation/bytebuddy/MockMethodAdvice.java \
		-i src/main/java/org/mockito/internal/creation/bytebuddy/InlineBytecodeGenerator.java || die
}

src_compile() {
	JAVA_JAR_FILENAME="mockito-core.jar"
	JAVA_SRC_DIR="src/main/java"
	java-pkg-simple_src_compile
	# save MockMethodDispatcher.class for compiling test-classes
	mkdir -p dispatcher/org/mockito/internal/creation/bytebuddy/inject || die
	cp target/classes/org/mockito/internal/creation/bytebuddy/inject/MockMethodDispatcher.class \
		dispatcher/org/mockito/internal/creation/bytebuddy/inject || die
	# rename according to mockito-core/build.gradle.kts
	mv target/classes/org/mockito/internal/creation/bytebuddy/inject/MockMethodDispatcher.class \
		target/classes/org/mockito/internal/creation/bytebuddy/inject/MockMethodDispatcher.raw || die
	jar cf mockito-core.jar -C target/classes . || die "refresh mockito-core.jar"
}
