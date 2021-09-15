# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An optimized Java interface to libffi"
HOMEPAGE="https://github.com/jnr/jffi"
SRC_URI="https://github.com/jnr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-3 )"
SLOT="1.2"
KEYWORDS="amd64 ~arm64 ppc64 x86 ~ppc-macos ~x64-macos"

CDEPEND="dev-libs/libffi:0="

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

# java 1.8 is needed because javah is called which is not in newer jdks
DEPEND="${CDEPEND}
	virtual/jdk:1.8
	test? (
		dev-java/ant-junit4:0
		dev-java/junit:4
	)"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.8-makefile.patch
	"${FILESDIR}"/${PN}-1.2.8-junit-4.11.patch
)

RESTRICT="test"

src_prepare() {
	default

	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die

	# misc fixes for Darwin
	if [[ ${CHOST} == *-darwin* ]] ; then
		local uarch
		# don't do multiarch
		# avoid using Xcode stuff
		# use Prefix' headers
		# don't mess with deployment target
		# set install_name
		use x64-macos && uarch=x86_64
		use ppc-macos && uarch=ppc
		sed -i \
			-e "/ARCHES +=/s/=.*$/= ${uarch}/" \
			-e "/XCODE=/s:=.*$:=${EPREFIX}:" \
			-e "/MACSDK/s/^/#/" \
			-e "/MACOSX_DEPLOYMENT_TARGET=/s/MAC/NOMAC/" \
			-e "/SOFLAGS =/s:=.*:= -install_name ${EPREFIX}/usr/lib/jffi-${SLOT}/libjffi-${SLOT}.jnilib:" \
			jni/GNUmakefile || die
	fi

	java-pkg_clean
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

src_compile() {
	# generate Version.java
	cat > src/main/java/com/kenai/jffi/Version.java <<-EOF
		package com.kenai.jffi;
		public final class Version {
			private Version() {}
			public static final int MAJOR = $(ver_cut 1);
			public static final int MINOR = $(ver_cut 2);
			public static final int MICRO = $(ver_cut 3);
		}
	EOF

	java-pkg-2_src_compile

	# generate headers
	mkdir -p build/jni
	javah -d build/jni -classpath target/classes \
		com.kenai.jffi.Foreign \
		com.kenai.jffi.ObjectBuffer \
		com.kenai.jffi.Version \
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

EANT_TEST_GENTOO_CLASSPATH="ant-junit4,junit-4"

src_test() {
	# build native test library
	emake BUILD_DIR=build -f libtest/GNUmakefile

	_JAVA_OPTIONS="-Djffi.boot.library.path=${S}/build/jni" \
		java-pkg-2_src_test
}

src_install() {
	local libname=".so"

	[[ ${CHOST} == *-darwin* ]] && libname=.jnilib
	java-pkg_doso build/jni/lib${PN}-$(ver_cut 1-2)${libname}

	# must by after _doso to have JAVA_PKG_LIBDEST set
	cat > boot.properties <<-EOF
		jffi.boot.library.path = ${JAVA_PKG_LIBDEST}
	EOF
	jar -uf target/${PN}.jar boot.properties || die

	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
