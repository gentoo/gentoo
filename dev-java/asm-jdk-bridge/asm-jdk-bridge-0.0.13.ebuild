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
KEYWORDS="~amd64 ~arm64 ~ppc64"

CP_DEPEND=">=dev-java/asm-9.9.1:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-25:*
	test? ( dev-java/junit:4 )
"

# asm-jdk-bridge-test/src/main/java/codes/rafael/asmjdkbridge/test/RecordComponents.java:6:
# error: records are not supported in -source 8
# public record RecordComponents(
#        ^
#   (use -source 16 or higher to enable records)
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-17:*
"

PATCHES=( "${FILESDIR}/asm-jdk-bridge-0.0.11-skipFailingTest.patch" )

JAVA_INTERMEDIATE_JAR_NAME="codes.rafael.asmjdkbridge"
JAVA_RELEASE_SRC_DIRS=(
	["9"]="asm-jdk-bridge/src/main/java-9"
	["24"]="asm-jdk-bridge/src/main/java-24"
)
JAVA_SRC_DIR="asm-jdk-bridge/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR=( asm-jdk-bridge-test/src/{main,test}/java )

src_prepare() {
	default # bug #780585
	java-pkg-2_src_prepare
	rm -r asm-jdk-bridge/src/main/java-9/codes || die "Dummy"
}
