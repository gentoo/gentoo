# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# doc USE flag is not in IUSE as the docs does not compile because of errors
JAVA_PKG_IUSE="examples source test"
MAVEN_ID="cglib:cglib:3.3.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_PV=RELEASE_${PV//./_}
MY_P=cglib-${MY_PV}

DESCRIPTION="cglib is a powerful, high performance and quality Code Generation Library"
HOMEPAGE="https://github.com/cglib/cglib"
SRC_URI="https://github.com/cglib/cglib/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

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

src_install() {
	java-pkg-simple_src_install

	use examples && java-pkg_doexamples --subdir samples ${MY_P}/cglib-sample/src/main/java
}
