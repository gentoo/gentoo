# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jnr/jffi/archive/refs/tags/jffi-1.3.6.tar.gz --slot 1.3 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jffi-1.3.6.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jnr:jffi:1.3.6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Foreign Function Interface"
HOMEPAGE="https://github.com/jnr/jffi"
SRC_URI="https://github.com/jnr/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.2"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}"/jffi-1.3.6-GNUmakefile.patch )
DOCS=( LICENSE README.md )

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"

# https://github.com/jnr/jffi/blob/eabdf09c3ec4fc8a54b684ff326e36b36b74e0da/build.xml#L26
JAVA_TEST_EXTRA_ARGS="-Djffi.library.path=${S}/build/jni -Djffi.boot.library.path=${S}/build/jni"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	cat > src/main/java/com/kenai/jffi/Version.java <<-EOF
		package com.kenai.jffi;
		import java.lang.annotation.Native;
		public final class Version {
			private Version() {}
			@Native
			public static final int MAJOR = $(ver_cut 1);
			@Native
			public static final int MINOR = $(ver_cut 2);
			@Native
			public static final int MICRO = $(ver_cut 3);
		}
	EOF
}

src_compile() {
	java-pkg-simple_src_compile

	# generate headers
	mkdir -p build/jni
	javac -h build/jni -classpath target/classes \
		${JAVA_SRC_DIR}/com/kenai/jffi/{Foreign,ObjectBuffer,Version}.java \
		|| die

	#build native library.
	local args=(
		SRC_DIR=jni
		JNI_DIR=jni
		BUILD_DIR=build/jni
		VERSION=$(ver_cut 1-2)
		USE_SYSTEM_LIBFFI=1
		CCACHE=
		-f jni/GNUmakefile
	)
	emake "${args[@]}"
}

src_test() {
	# build native test library
	emake BUILD_DIR=build -f libtest/GNUmakefile
	java-pkg-simple_src_test
}

src_install() {
	default

	local libname=".so"
	java-pkg_doso build/jni/lib${PN}-$(ver_cut 1-2)${libname}

	# must be after _doso to have JAVA_PKG_LIBDEST set
	cat > boot.properties <<-EOF
		jffi.boot.library.path = ${JAVA_PKG_LIBDEST}
	EOF
	jar -uf ${PN}.jar boot.properties || die

	java-pkg-simple_src_install
}
