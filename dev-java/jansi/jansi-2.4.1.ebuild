# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.fusesource.jansi:jansi:2.4.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple toolchain-funcs

DESCRIPTION="Jansi is a java library for generating and interpreting ANSI escape sequences."
HOMEPAGE="https://fusesource.github.io/jansi/"
# downloading jni.h and jni_md.h according to Makefile
SRC_URI="
	https://github.com/fusesource/${PN}/archive/refs/tags/${P}.tar.gz
	https://raw.githubusercontent.com/openjdk/jdk/jdk-11%2B28/src/java.base/share/native/include/jni.h
	-> ${P}-jni.h
	https://raw.githubusercontent.com/openjdk/jdk/jdk-11%2B28/src/java.base/unix/native/include/jni_md.h
	-> ${P}-jni_md.h
"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm64 ~ppc64"
RESTRICT="test"	#839681

DEPEND="
	test? ( dev-java/junit:5 )
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( {changelog,readme}.md license.txt )

JAVA_MAIN_CLASS="org.fusesource.jansi.AnsiMain"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,junit-5"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	# Remove this directory containing libjansi.so, libjansi.jnilib and jansi.dll
	rm -r "${JAVA_RESOURCE_DIRS}/org/fusesource/jansi/internal/native" || die

	cp "${DISTDIR}/${P}-jni.h" src/main/native/jni.h || die
	cp "${DISTDIR}/${P}-jni_md.h" src/main/native/jni_md.h || die
}

src_compile() {
	java-pkg-simple_src_compile

	# build native library.
	local args=(
		CCFLAGS="${CFLAGS} ${CXXFLAGS} -Os -fPIC -fvisibility=hidden"
		LINKFLAGS="-shared ${LDFLAGS}"
		CC="$(tc-getCC)"
		STRIP="$(tc-getSTRIP)"
		LIBNAME="libjansi-$(ver_cut 1-2).so"
	)
	emake "${args[@]}" native
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_doso target/native--/libjansi-$(ver_cut 1-2).so
}
