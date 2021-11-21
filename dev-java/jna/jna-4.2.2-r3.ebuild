# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="net.java.dev.jna:jna:4.2.2"

inherit java-pkg-2 java-ant-2 toolchain-funcs

DESCRIPTION="Java Native Access (JNA)"
HOMEPAGE="https://github.com/java-native-access/jna"
SRC_URI="https://github.com/java-native-access/jna/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="+awt +nio-buffers test"

REQUIRED_USE="test? ( awt nio-buffers )"

# The tests stall immediately on some systems (not current stable?) when
# the sandbox is active but pass successfully otherwise. Chewi has not
# been able to determine why. This began in 4.2.0 as 4.1.0 worked
# fine. Someone bisect it please. :)
RESTRICT="test"

CDEPEND="dev-libs/libffi:="
DEPEND="${CDEPEND}
	virtual/jdk:1.8
	x11-libs/libXt
	test? (
		dev-java/ant-junit:0
		dev-java/guava:20
		dev-java/javassist:3
		dev-java/reflections:0
	)"
RDEPEND="${CDEPEND}
	virtual/jre:1.8"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PV}-build.xml.patch
	"${FILESDIR}"/${PV}-makefile-flags.patch
)

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="native jar contrib-jars"
EANT_EXTRA_ARGS="-Ddynlink.native=true"
EANT_TEST_EXTRA_ARGS="-Dheadless=true -Djava.io.tmpdir=${T}"
EANT_TEST_GENTOO_CLASSPATH="guava-20,javassist-3,reflections"

src_prepare() {
	default

	# delete bundled jars and copy of libffi
	# except native jars because build.xml needs them all
	find ! -path "./lib/native/*" -name "*.jar" -delete || die
	rm -r native/libffi || die

	if ! use awt ; then
		sed -i -E "s/^(CDEFINES=.*)/\1 -DNO_JAWT/g" native/Makefile || die
	fi

	if ! use nio-buffers ; then
		sed -i -E "s/^(CDEFINES=.*)/\1 -DNO_NIO_BUFFERS/g" native/Makefile || die
	fi

	java-pkg-2_src_prepare
}

src_configure() {
	tc-export CC
}

src_install() {
	java-pkg_newjar build/${PN}-min.jar
	java-pkg_dojar contrib/platform/dist/${PN}-platform.jar
	java-pkg_doso build/native-*/libjnidispatch.so

	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc doc/javadoc
}

src_test() {
	java-pkg-2_src_test
}
