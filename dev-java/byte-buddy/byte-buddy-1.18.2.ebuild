# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_PROVIDES="net.bytebuddy:byte-buddy-agent:${PV} net.bytebuddy:byte-buddy:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Offers convenience for attaching an agent to the local or a remote VM"
HOMEPAGE="https://bytebuddy.net"
SRC_URI="https://github.com/raphw/byte-buddy/archive/${P}.tar.gz"
S="${WORKDIR}/byte-buddy-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

# Min java 11 because of module-info.
DEPEND="
	>=dev-java/asm-9.9.1:0
	>=dev-java/asm-jdk-bridge-0.0.13:0
	>=dev-java/findbugs-annotations-3.0.1:0
	>=dev-java/jna-5.18.1:0
	>=dev-java/jsr305-3.0.2-r1:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/mockito-2.28.2-r1:2
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="asm asm-jdk-bridge findbugs-annotations jna jsr305"
JAVADOC_CLASSPATH="${JAVA_CLASSPATH_EXTRA}"
JAVADOC_SRC_DIRS=( byte-buddy{,-agent}/src/main/java )

src_prepare() {
	java-pkg_clean ! -path "./byte-buddy-dep/src/test/*"	# Keep test-classes
	java-pkg-2_src_prepare

	# instead of shading byte-buddy-dep we move it into byte-buddy.
	mv byte-buddy{-dep,}/src/main/java || die "cannot move sources"
}

src_compile() {
	einfo "Compiling byte-buddy-agent.jar"
	JAVA_INTERMEDIATE_JAR_NAME="net.bytebuddy.agent"
	JAVA_JAR_FILENAME="byte-buddy-agent.jar"
	JAVA_MODULE_INFO_OUT="byte-buddy-agent/src/main"
	JAVA_RESOURCE_DIRS="byte-buddy-agent/src/main/resources"
	JAVA_SRC_DIR="byte-buddy-agent/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy-agent.jar"
	rm -r target || die

	einfo "Compiling byte-buddy.jar"
	JAVA_INTERMEDIATE_JAR_NAME="net.bytebuddy"
	JAVA_JAR_FILENAME="byte-buddy.jar"
	JAVA_MODULE_INFO_OUT="byte-buddy/src/main"
	JAVA_MAIN_CLASS="net.bytebuddy.build.Plugin\$Engine\$Default"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR="byte-buddy/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_test() {
	# instead of shading byte-buddy-dep we move it into byte-buddy.
	mv byte-buddy{-dep,}/src/test || die "cannot move tests"

	JAVAC_ARGS="-g"
	JAVA_TEST_GENTOO_CLASSPATH="asm asm-jdk-bridge junit-4 mockito-2"

	einfo "Testing byte-buddy-agent"
	# https://github.com/raphw/byte-buddy/issues/1321#issuecomment-1252776459
	JAVA_TEST_EXTRA_ARGS=( -Dnet.bytebuddy.test.jnapath="${EPREFIX}/usr/$(get_libdir)/jna/" )
	JAVA_TEST_SRC_DIR="byte-buddy-agent/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing byte-buddy"
	JAVA_TEST_RESOURCE_DIRS=( byte-buddy/src/test/{resources,precompiled*} )
	JAVA_TEST_SRC_DIR="byte-buddy/src/test/java"

	JAVA_TEST_EXCLUDES=(
		# all tests in this class fail, https://bugs.gentoo.org/863386
		net.bytebuddy.build.CachedReturnPluginTest
	)
	java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar "byte-buddy-agent.jar"
	java-pkg-simple_src_install

	if use source; then
		java-pkg_dosrc "byte-buddy-agent/src/main/java/*"
		java-pkg_dosrc "byte-buddy/src/main/java/*"
	fi
}
