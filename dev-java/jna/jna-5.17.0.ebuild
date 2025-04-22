# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_PROVIDES="
	net.java.dev.jna:jna:${PV}
	net.java.dev.jna:jna-platform:${PV}
"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple toolchain-funcs

DESCRIPTION="Java Native Access"
HOMEPAGE="https://github.com/java-native-access/jna"
SRC_URI="https://github.com/java-native-access/jna/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="|| ( Apache-2.0 LGPL-2.1+ )"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64"

BDEPEND="virtual/pkgconfig"

CDEPEND=">=dev-libs/libffi-3.4:="

DEPEND="
	${CDEPEND}
	>=virtual/jdk-11:*
	x11-base/xorg-proto:0
	x11-libs/libXt
	test? ( dev-java/reflections:0 )
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( README.md CHANGES.md OTHERS TODO )

JAVADOC_SRC_DIRS=( {contrib/platform/,}src )

PATCHES=(
	"${FILESDIR}/5.11.0-makefile-flags.patch"
	"${FILESDIR}/jna-5.11.0-no-Werror.patch"
	"${FILESDIR}/jna-5.13.0-testpath.patch"
	"${FILESDIR}/jna-5.13.0-LibCTest.patch"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean

	# https://github.com/java-native-access/jna/blob/5.13.0/build.xml#L402-L407
	sed \
		-e "/VERSION =/s:TEMPLATE:${PV}:" \
		-e '/VERSION_NATIVE =/s:TEMPLATE:5.1.0:' \
		-i src/com/sun/jna/Version.java || die
}

src_compile() {
	einfo "Compiling jna.jar"
	JAVA_INTERMEDIATE_JAR_NAME="com.sun.jna"
	JAVA_JAR_FILENAME="jna.jar"
	JAVA_MAIN_CLASS="com.sun.jna.Native"
	JAVA_MODULE_INFO_OUT="src"
	JAVA_SRC_DIR="src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jna.jar"
	rm -r target || die

	einfo "Compiling jna-platform.jar"
	JAVA_INTERMEDIATE_JAR_NAME="com.sun.jna.platform"
	JAVA_JAR_FILENAME="jna-platform.jar"
	JAVA_MAIN_CLASS=""	# Did the eclass forget to unset this variable?
	JAVA_MODULE_INFO_OUT="contrib/platform/src"
	JAVA_SRC_DIR="contrib/platform/src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jna-platform.jar"
	rm -r target || die

	#954164
	rm contrib/platform/src/com.sun.jna.platform/versions/9/module-info.java || die
	use doc && ejavadoc

	einfo "Generating headers com_sun_jna_Native.h com_sun_jna_Function.h"
	ejavac -h native -classpath "src" \
		"src/com/sun/jna/Function.java" \
		"src/com/sun/jna/Native.java" || die

	einfo "Building native library"
	cd native || die
	local args=(
		CC="$(tc-getCC)"
		STRIP=true
		DYNAMIC_LIBFFI=true
	)
	# Using -j1 since otherwise fails to build:
	# cannot find ../build/native/libtestlib.so: No such file or directory
	# [Makefile:505: ../build/native/libtestlib2.so] Error 1
	emake -j1 "${args[@]}"
}

src_test() {
	rm -r  contrib/platform/test/com/sun/jna/platform/{mac,unix,win32} || die
	rm -r test/com/sun/jna/wince || die
	rm -r test/com/sun/jna/win32 || die

	# 1) testLoadFromJarAbsolute(com.sun.jna.LibraryLoadTest)
	# java.lang.UnsatisfiedLinkError: Unable to load library '/libtestlib-jar.so':
	# /libtestlib-jar.so: cannot open shared object file: No such file or directory
	jar cvf build/jna-test.jar \
		-C build/native libtestlib-jar.so \
		-C test com/sun/jna/data || die
	JAVA_GENTOO_CLASSPATH_EXTRA+=":build/jna-test.jar"

	JAVA_TEST_EXTRA_ARGS=(
		-Djna.nosys=true
		-Djna.boot.library.path=build/native
		-Djna.library.path=build/native
	)

	JAVA_TEST_GENTOO_CLASSPATH="junit-4,reflections"

	einfo "Testing jna-platform"
	JAVA_TEST_RUN_ONLY=( com.sun.jna.platform.linux.XAttrUtilTest )	# If not run first, it would fail.
	JAVA_TEST_SRC_DIR="contrib/platform/test"
	pushd "${JAVA_TEST_SRC_DIR}" > /dev/null || die
		local JAVA_TEST_RUN_LATER=$(find * -name '*Test.java' ! -name 'XAttrUtilTest.java' )
	popd
	JAVA_TEST_RUN_LATER="${JAVA_TEST_RUN_LATER//.java}"
	JAVA_TEST_RUN_ONLY+=( ${JAVA_TEST_RUN_LATER//\//.} )
	java-pkg-simple_src_test

	einfo "Testing jna"
	JAVA_TEST_SRC_DIR="test"

	# Some tests need to run first, otherwise they would fail.
	JAVA_TEST_RUN_ONLY=(
		com.sun.jna.CallbacksTest
		com.sun.jna.DirectTest
		com.sun.jna.UnionTest
	)
	JAVA_TEST_RUN_ONLY+=( com.sun.jna.TypeMapperTest )
	JAVA_TEST_RUN_ONLY+=( com.sun.jna.NativeTest )

	pushd "${JAVA_TEST_SRC_DIR}" > /dev/null || die
		# Here, those tests which were moved to top of the array are excluded.
		# Also exclude 2 tests which must not run before the others.
		local JAVA_TEST_RUN_LATER=$(find * \
			-name "*Test.java" \
			! -name 'CallbacksTest.java' \
			! -name 'DirectTest.java' \
			! -name 'UnionTest.java' \
			! -name 'TypeMapperTest.java' \
			! -name 'NativeTest.java' \
			! -name 'DirectCallbacksTest.java' \
			! -name 'VMCrashProtectionTest.java' \
			)
	popd
	JAVA_TEST_RUN_LATER="${JAVA_TEST_RUN_LATER//.java}"
	JAVA_TEST_RUN_ONLY+=( ${JAVA_TEST_RUN_LATER//\//.} )

	# This one makes trouble if run before some others.
	JAVA_TEST_RUN_ONLY+=( com.sun.jna.VMCrashProtectionTest )
	java-pkg-simple_src_test

	# There was 1 failure:
	# 1) testDefaultCallbackExceptionHandler(com.sun.jna.CallbacksTest)
	# junit.framework.AssertionFailedError: Default handler not called
	# 	at junit.framework.Assert.fail(Assert.java:57)
	# 	at junit.framework.Assert.assertTrue(Assert.java:22)
	# 	at junit.framework.TestCase.assertTrue(TestCase.java:192)
	# 	at com.sun.jna.CallbacksTest.testDefaultCallbackExceptionHandler(CallbacksTest.java:865)
	# Cannot run in same batch as 'com.sun.jna.CallbacksTest'.
	# It would break other tests if run before and segmentation fault if run after.
	JAVA_TEST_RUN_ONLY=( com.sun.jna.DirectCallbacksTest )
	java-pkg-simple_src_test
}

src_install() {
	default
	java-pkg_dojar jna.jar jna-platform.jar
	java-pkg_doso build/native/libjnidispatch.so

	use doc && java-pkg_dojavadoc target/api

	if use source; then
		java-pkg_dosrc "src/*"
		java-pkg_dosrc "contrib/platform/src/*"
	fi
}
