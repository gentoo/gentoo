# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2 toolchain-funcs vcs-snapshot

DESCRIPTION="Java Native Access (JNA)"
HOMEPAGE="https://github.com/twall/jna#readme"
SRC_URI="https://github.com/twall/jna/tarball/3.4.0 -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+awt +nio-buffers"
REQUIRED_USE="test? ( awt nio-buffers )"

COMMON_DEP="
	virtual/libffi"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.6
	dev-java/ant-nodeps:0
	virtual/pkgconfig
	test? (
		dev-java/ant-junit:0
		dev-java/ant-trax:0
	)"

java_prepare() {
	# delete bundled jars and copy of libffi
	find -name "*.jar" -exec rm -v {} + || die
	rm -r native/libffi || die

	epatch "${FILESDIR}/${PV}-build.xml.patch"
	# respect CFLAGS, don't inhibit warnings, honour CC
	epatch "${FILESDIR}/${P}-makefile-flags.patch"
	tc-export CC

	# Build to same directory on 64-bit archs.
	mkdir build || die
	ln -snf build build-d64 || die

	if ! use awt ; then
		sed -i -E "s/^(CDEFINES=.*)/\1 -DNO_JAWT/g" native/Makefile || die
	fi

	if ! use nio-buffers ; then
		sed -i -E "s/^(CDEFINES=.*)/\1 -DNO_NIO_BUFFERS/g" native/Makefile || die
	fi
}

EANT_BUILD_TARGET="jar contrib-jars"
EANT_ANT_TASKS="ant-nodeps"
EANT_EXTRA_ARGS="-Ddynlink.native=true"

EANT_TEST_ANT_TASKS="ant-junit ant-nodeps ant-trax"
src_test() {
	local sysprops=""

	# crashes vm (segfault)
	sed -i -e 's|testRegisterMethods|no&|' test/com/sun/jna/DirectTest.java || die

	# crashes vm, java 7 only (icedtea-7,  oracle-jdk-bin-1.7)
	sed -i -e 's|testGCCallbackOnFinalize|no&|' test/com/sun/jna/CallbacksTest.java || die

	sysprops+=" -Djava.awt.headless=true"
	sysprops+=" -Djava.io.tmpdir=${T}" #to ensure exec mount

	mkdir -p lib || die
	java-pkg_jar-from --into lib --build-only junit

	# need to use _JAVA_OPTIONS or add them to the build.xml. ANT_OPTS won't
	# survive the junit task.
	_JAVA_OPTIONS="${sysprops}" java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	java-pkg_dojar contrib/platform/dist/platform.jar
	java-pkg_doso build/native/libjnidispatch.so

	java-pkg_register-optional-dependency emul-linux-x86-jna #313209

	use source && java-pkg_dosrc src/com
	use doc && java-pkg_dojavadoc doc/javadoc
}
