# Copyright 1999-2023 Gentoo Authors
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
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

BDEPEND="
	virtual/pkgconfig
"

CDEPEND="
	>=dev-libs/libffi-3.4:=
"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/reflections:0
	)
	${CDEPEND}
	x11-libs/libXt
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

DOCS=( README.md CHANGES.md OTHERS TODO )
PATCHES=(
	"${FILESDIR}/5.11.0-makefile-flags.patch"
	"${FILESDIR}/jna-5.11.0-no-Werror.patch"
	"${FILESDIR}/jna-5.13.0-testpath.patch"
)

src_prepare() {
	default
	java-pkg-2_src_prepare
	java-pkg_clean
	mkdir -p "res/META-INF" || die
	echo "Main-Class: com.sun.jna.Native" > "res/META-INF/MANIFEST.MF" || die

	# https://github.com/java-native-access/jna/blob/5.13.0/build.xml#L402-L407
	sed \
		-e "/VERSION =/s:TEMPLATE:${PV}:" \
		-e '/VERSION_NATIVE =/s:TEMPLATE:5.1.0:' \
		-i src/com/sun/jna/Version.java || die
}

src_compile() {
	einfo "Compiling jna.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.sun.jna"
	JAVA_JAR_FILENAME="jna.jar"
	JAVA_RESOURCE_DIRS="res"
	JAVA_SRC_DIR="src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jna.jar"
	rm -r target || die

	einfo "Compiling jna-platform.jar"
	JAVA_AUTOMATIC_MODULE_NAME="com.sun.jna.platform"
	JAVA_JAR_FILENAME="jna-platform.jar"
	JAVA_RESOURCE_DIRS=""
	JAVA_SRC_DIR="contrib/platform/src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jna-platform.jar"
	rm -r target || die

	if use doc; then
		einfo "Compiling javadocs"
		JAVA_SRC_DIR=(
			"src"
			"contrib/platform/src"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi

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
	JAVA_TEST_EXTRA_ARGS=(
		-Djna.nosys=true
		-Djna.boot.library.path=build/native
		-Djna.library.path=build/native
	)
	JAVA_TEST_GENTOO_CLASSPATH="
		junit-4
		reflections
	"

	JAVA_TEST_SRC_DIR="contrib/platform/test"
	rm -r  contrib/platform/test/com/sun/jna/platform/{mac,unix,win32} || die
	JAVA_TEST_EXCLUDES=(
		# 1) testGetXAttr(com.sun.jna.platform.linux.XAttrUtilTest)
		# java.io.IOException: errno: 95
		#         at com.sun.jna.platform.linux.XAttrUtil.setXAttr(XAttrUtil.java:85)
		#         at com.sun.jna.platform.linux.XAttrUtil.setXAttr(XAttrUtil.java:70)
		#         at com.sun.jna.platform.linux.XAttrUtil.setXAttr(XAttrUtil.java:56)
		#         at com.sun.jna.platform.linux.XAttrUtilTest.testGetXAttr(XAttrUtilTest.java:83)
		# 2) setXAttr(com.sun.jna.platform.linux.XAttrUtilTest)
		# java.io.IOException: errno: 95
		#         at com.sun.jna.platform.linux.XAttrUtil.setXAttr(XAttrUtil.java:85)
		#         at com.sun.jna.platform.linux.XAttrUtil.setXAttr(XAttrUtil.java:70)
		#         at com.sun.jna.platform.linux.XAttrUtil.setXAttr(XAttrUtil.java:56)
		#         at com.sun.jna.platform.linux.XAttrUtilTest.setXAttr(XAttrUtilTest.java:53)
		com.sun.jna.platform.linux.XAttrUtilTest
	)
	java-pkg-simple_src_test

	JAVA_TEST_SRC_DIR="test"
	rm -r test/com/sun/jna/wince || die
	rm -r test/com/sun/jna/win32 || die

	# 1) testLoadFromJarAbsolute(com.sun.jna.LibraryLoadTest)
	# java.lang.UnsatisfiedLinkError: Unable to load library '/libtestlib-jar.so':
	# /libtestlib-jar.so: cannot open shared object file: No such file or directory
	jar cvf build/jna-test.jar \
		-C build/native libtestlib-jar.so || die
	JAVA_GENTOO_CLASSPATH_EXTRA+=":build/jna-test.jar"

	JAVA_TEST_EXCLUDES=(
		com.sun.jna.CallbacksTest # Needs to run separately
		com.sun.jna.DirectTest # Needs to run separately
		com.sun.jna.ELFAnalyserTest # NPE
		com.sun.jna.NativeTest # Needs to run separately
		com.sun.jna.UnionTest # Needs to run separately
		com.sun.jna.VMCrashProtectionTest # Needs to run separately
	)
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY=(
		com.sun.jna.CallbacksTest
		com.sun.jna.DirectTest
		com.sun.jna.UnionTest
	)
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY=( com.sun.jna.NativeTest )
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY=( com.sun.jna.VMCrashProtectionTest )
	java-pkg-simple_src_test
}

src_install() {
	default
	java-pkg_dojar jna.jar jna-platform.jar
	java-pkg_doso build/native/libjnidispatch.so

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "src/*"
		java-pkg_dosrc "contrib/platform/src/*"
	fi
}
