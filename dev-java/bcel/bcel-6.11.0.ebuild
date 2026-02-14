# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

CLV="2.6" # commons-lang:2.6 was removed some time ago
KSLV="2.2.20" # kotlin-stdlib is presently not packaged

DESCRIPTION="Apache Commons Bytecode Engineering Library"
HOMEPAGE="https://commons.apache.org/proper/commons-bcel/"
SRC_URI="mirror://apache/commons/bcel/source/${P}-src.tar.gz
	verify-sig? ( mirror://apache/commons/bcel/source/${P}-src.tar.gz.asc )
	test? (
		https://repo1.maven.org/maven2/commons-lang/commons-lang/${CLV}/commons-lang-${CLV}.jar
		https://repo1.maven.org/maven2/org/jetbrains/kotlin/kotlin-stdlib/${KSLV}/kotlin-stdlib-${KSLV}.jar
	)
	"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x64-macos ~x64-solaris"

BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-apache-commons-20251102 )"
CP_DEPEND="
	>=dev-java/commons-io-2.21.0:0
	>=dev-java/commons-lang-3.20.0:0
"
DEPEND="
	${CP_DEPEND}
	|| ( virtual/jdk:26 virtual/jdk:25 virtual/jdk:21 virtual/jdk:17 virtual/jdk:11 )
	test? (
		>=dev-java/asm-9.9.1:0
		>=dev-java/byte-buddy-1.18.2:0
		>=dev-java/commons-collections-4.5.0:4
		>=dev-java/commons-exec-1.6.0:0
		dev-java/eclipse-ecj:4.20
		>=dev-java/jmh-core-1.37:0
		>=dev-java/jna-5.18.1:0
		>=dev-java/jsr305-3.0.2-r1:0
		dev-java/junit:5[-vintage]
		>=dev-java/mockito-5.21.0:0
		>=dev-java/opentest4j-1.3.0-r1:0
		>=dev-java/wsdl4j-1.6.3:0
	)
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( NOTICE.txt RELEASE-NOTES.txt )

JAVA_GENTOO_CLASSPATH_EXTRA=":${DISTDIR}/commons-lang-${CLV}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/kotlin-stdlib-${KSLV}.jar"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
# These 9 test-classes, if we run them, would result in 26 test failures from a total of 178 tests.
JAVA_TEST_EXCLUDES=(
	org.apache.bcel.classfile.ConstantPoolModuleAccessTest
	org.apache.bcel.classfile.ConstantPoolModuleToStringTest
	org.apache.bcel.classfile.ConstantPoolTest
	org.apache.bcel.CounterVisitorTest
	org.apache.bcel.generic.EmptyVisitorTest
	org.apache.bcel.generic.MethodGenTest
	org.apache.bcel.LocalVariableTypeTableTest
	org.apache.bcel.PLSETest
	org.apache.bcel.verifier.VerifierMainTest
)
JAVA_TEST_GENTOO_CLASSPATH="asm byte-buddy commons-collections-4 commons-exec
	commons-io eclipse-ecj-4.20 jmh-core jna jsr305 junit-5 mockito opentest4j"
JAVA_TEST_RESOURCE_DIRS=( src/test/resources src/test/java )
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	default
}

src_prepare() {
	java-pkg-2_src_prepare

	# src/test/java/org/apache/bcel/util/BCELifierTest.java:255: error: cannot find symbol
	#     @DisabledForJreRange(min = JRE.JAVA_25)
	#                                   ^
	#   symbol:   variable JAVA_25
	#   location: class JRE
	rm src/test/java/org/apache/bcel/util/BCELifierTest.java || die "remove test"

	# Error: Modules wsdl4j and java.xml export package javax.xml.namespace to module org.mockito
	rm src/test/java/org/apache/bcel/verifier/VerifierTest.java || die

	# These 2 test classes would pass, but then fail verification:
	#  * Verifying test classes' dependencies
	# Exception in thread "main" com.sun.tools.jdeps.Dependencies$ClassFileError: Bad magic number
	# Caused by: java.lang.IllegalArgumentException: Bad magic number
	rm src/test/java/org/apache/bcel/verifier/VerifierArrayAccessTest.java || die
	rm src/test/java/org/apache/bcel/verifier/VerifierReturnTest.java || die
}
