# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"
MAVEN_ID="com.github.jnr:jnr-ffi:2.2.17"

inherit java-pkg-2 java-pkg-simple junit5 toolchain-funcs

DESCRIPTION="A library for invoking native functions from java"
HOMEPAGE="https://github.com/jnr/jnr-ffi"
SRC_URI="https://github.com/jnr/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="
	dev-java/asm:0
	>=dev-java/jffi-1.3.13:0
	dev-java/jnr-a64asm:2
	dev-java/jnr-x86asm:1.0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/opentest4j:0 )
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

PATCHES=( "${FILESDIR}/jnr-ffi-2.2.17-r1-GetLoadedLibrariesTest.patch" )

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXTRA_ARGS=( -Djava.library.path=build )
JAVA_TEST_GENTOO_CLASSPATH="junit-5 opentest4j"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	emake -f libtest/GNUmakefile CC="$(tc-getCC)"
	junit5_src_test
}
