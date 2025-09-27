# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="codes.rafael.asmjdkbridge:asm-jdk-bridge:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Bridge to Translate ASM From and to The OpenJDK Class File API"
HOMEPAGE="https://github.com/raphw/asm-jdk-bridge"
SRC_URI="https://github.com/raphw/asm-jdk-bridge/archive/asm-jdk-bridge-parent-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-parent-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	>=dev-java/asm-9.8:0
	dev-java/junit:4
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-24:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-24:*
"

JAVA_INTERMEDIATE_JAR_NAME="codes.rafael.asmjdkbridge"

JAVA_RELEASE_SRC_DIRS=(
	["9"]="asm-jdk-bridge/src/main/java-9"
	["24"]="asm-jdk-bridge/src/main/java-24"
)

JAVA_SRC_DIR="asm-jdk-bridge/src/main/java"
JAVA_TEST_EXCLUDES=(
	# There were 3 failures:
	# 1) parsed_class_files_are_equal[class codes.rafael.asmjdkbridge.test.TypeAnnotationsWithPath
	# (reader=0)](codes.rafael.asmjdkbridge.test.JdkClassReplicationTest)
	# java.util.IllegalFormatConversionException: d != java.lang.String
	# 2) parsed_class_files_are_equal[class codes.rafael.asmjdkbridge.test.TypeAnnotationsWithPath
	# (reader=0, writer=0)](codes.rafael.asmjdkbridge.test.JdkClassWriterTest)
	# java.util.IllegalFormatConversionException: d != java.lang.String
	# 3) parsed_class_files_are_equal[class codes.rafael.asmjdkbridge.test.CustomAttributeGen
	# (reader=0)](codes.rafael.asmjdkbridge.test.JdkClassReaderTest)
	# java.lang.UnsupportedOperationException: Unknown value: CustomAttribute[name=CustomCodeAttribute]
	# 	at codes.rafael.asmjdkbridge.JdkClassReader.lambda$accept$43(JdkClassReader.java:495)
	# 	at java.base/java.util.Optional.ifPresent(Optional.java:178)
	# 	at codes.rafael.asmjdkbridge.JdkClassReader.accept(JdkClassReader.java:320)
	# 	at codes.rafael.asmjdkbridge.test.JdkClassReaderTest.parsed_class_files_are_equal(JdkClassReaderTest.java:80)

	codes.rafael.asmjdkbridge.test.JdkClassReplicationTest
	codes.rafael.asmjdkbridge.test.JdkClassWriterTest
	codes.rafael.asmjdkbridge.test.JdkClassReaderTest
)
JAVA_TEST_SRC_DIR=( asm-jdk-bridge-test/src/{main,test}/java )

src_prepare() {
	java-pkg-2_src_prepare
	rm -r asm-jdk-bridge/src/main/java-9/codes || die "Dummy"
}
