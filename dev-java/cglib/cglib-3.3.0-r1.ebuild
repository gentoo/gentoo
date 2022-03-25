# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# doc USE flag is not in IUSE as the docs does not compile because of errors
JAVA_PKG_IUSE="examples source test"
MAVEN_ID="cglib:cglib:3.3.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_PV=RELEASE_${PV//./_}
MY_P=cglib-${MY_PV}

DESCRIPTION="cglib is a powerful, high performance and quality Code Generation Library"
HOMEPAGE="https://github.com/cglib/cglib"
SRC_URI="https://github.com/cglib/cglib/archive//${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

CDEPEND="dev-java/ant-core:0
	dev-java/asm:9
"
DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"
RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="asm-9 ant-core"
JAVA_SRC_DIR="${MY_P}/${PN}/src/main/java"
JAVA_RESOURCE_DIRS="${MY_P}/${PN}/src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="${MY_P}/${PN}/src/test/java"
JAVA_TEST_EXCLUDES=(
	"net.sf.cglib.CodeGenTestCase"		# not a test class
	"net.sf.cglib.TestAll"
	"net.sf.cglib.TestGenerator"		# not a test class
	"net.sf.cglib.proxy.TestEnhancer"	# broken tests
	"net.sf.cglib.proxy.TestInterceptor"	# not a test class
	"net.sf.cglib.reflect.TestFastClass"	# broken tests
)

src_test() {
	# Caused by: net.sf.cglib.core.CodeGenerationException:
	# java.lang.reflect.InaccessibleObjectException-->Unable to make protected final java.lang.Class
	# java.lang.ClassLoader.defineClass(java.lang.String,byte[],int,int,java.security.ProtectionDomain)
	# throws java.lang.ClassFormatError accessible: module java.base does not "opens java.lang" to unnamed module @42bb2aee

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "17" ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
	fi

	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install

	use examples && java-pkg_doexamples --subdir samples ${MY_P}/cglib-sample/src/main/java
}
