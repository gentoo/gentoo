# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jnr:jffi:1.3.10"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Foreign Function Interface"
HOMEPAGE="https://github.com/jnr/jffi"
SRC_URI="https://github.com/jnr/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="1.3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*
	>=dev-libs/libffi-3.4.2-r2:="
RDEPEND=">=virtual/jre-1.8:*
	>=dev-libs/libffi-3.4.2-r2:="

PATCHES=( "${FILESDIR}"/jffi-1.3.8-GNUmakefile.patch )

JAVA_AUTOMATIC_MODULE_NAME="org.jnrproject.jffi"
JAVA_SRC_DIR="src/main/java"

# https://github.com/jnr/jffi/blob/b6ad5c066a6346072ea04f8ffa8177204aadcb13/build.xml#L26
JAVA_TEST_EXTRA_ARGS="-Djffi.library.path=${S}/build/jni -Djffi.boot.library.path=${S}/build/jni"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
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

	# https://bugs.gentoo.org/829820
	if use arm; then
		sed \
			-e '/import org.junit.Test/a import org.junit.Ignore;' \
			-e '/invokeHeapDO()/i @Ignore' \
			-e '/invokeHeapNO()/i @Ignore' \
			-e '/invokeHeapOD()/i @Ignore' \
			-e '/invokeHeapON()/i @Ignore' \
			-e '/invokeHeapOO()/i @Ignore' \
			-e '/invokeHeapO()/i @Ignore' \
			-e '/invokeNativeDO()/i @Ignore' \
			-e '/invokeNativeNO()/i @Ignore' \
			-e '/invokeNativeOD()/i @Ignore' \
			-e '/invokeNativeON()/i @Ignore' \
			-e '/invokeNativeOO()/i @Ignore' \
			-e '/invokeNativeO()/i @Ignore' \
			-i src/test/java/com/kenai/jffi/InvokerTest.java || die
		sed \
			-e '/import org.junit.Test/a import org.junit.Ignore;' \
			-e '/returnDefaultF128HighPrecision/i @Ignore' \
			-i src/test/java/com/kenai/jffi/NumberTest.java || die
	fi
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

	# https://github.com/jnr/jffi/issues/60
	LC_ALL=C java-pkg-simple_src_test
}

src_install() {
	local libname=".so"
	java-pkg_doso build/jni/lib${PN}-$(ver_cut 1-2)${libname}

	# must be after _doso to have JAVA_PKG_LIBDEST set
	cat > boot.properties <<-EOF
		jffi.boot.library.path = ${JAVA_PKG_LIBDEST}
	EOF
	jar -uf ${PN}.jar boot.properties || die

	java-pkg-simple_src_install
}
