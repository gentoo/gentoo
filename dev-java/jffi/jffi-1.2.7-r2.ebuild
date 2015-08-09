# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2 versionator vcs-snapshot

DESCRIPTION="An optimized Java interface to libffi"
HOMEPAGE="https://github.com/jnr/jffi"
SRC_URI="https://github.com/jnr/jffi/tarball/${PV} -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-3 )"
SLOT="1.2"
KEYWORDS="amd64 ~ppc x86 ~ppc-macos ~x64-macos ~x86-macos"

COMMON_DEP="virtual/libffi:0"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	virtual/pkgconfig
	test? (
		dev-java/ant-junit4:0
		dev-java/junit:4
	)"

java_prepare() {
	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-junit-4.11.patch

	# misc fixes for Darwin
	if [[ ${CHOST} == *-darwin* ]] ; then
		local uarch
		# don't do multiarch
		# avoid using Xcode stuff
		# use Prefix' headers
		# don't mess with deployment target
		# set install_name
		use x64-macos && uarch=x86_64
		use x86-macos && uarch=i386
		use ppc-macos && uarch=ppc
		sed -i \
			-e "/ARCHES +=/s/=.*$/= ${uarch}/" \
			-e "/XCODE=/s:=.*$:=${EPREFIX}:" \
			-e "/MACSDK/s/^/#/" \
			-e "/MACOSX_DEPLOYMENT_TARGET=/s/MAC/NOMAC/" \
			-e "/SOFLAGS =/s:=.*:= -install_name ${EPREFIX}/usr/lib/jffi-${SLOT}/libjffi-${SLOT}.jnilib:" \
			jni/GNUmakefile || die
	fi

	find "${WORKDIR}" -iname '*.jar' -delete || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"
src_compile() {
	# generate Version.java
	cat > src/main/java/com/kenai/jffi/Version.java <<-EOF
		package com.kenai.jffi;
		public final class Version {
			private Version() {}
			public static final int MAJOR = $(get_version_component_range 1);
			public static final int MINOR = $(get_version_component_range 2);
			public static final int MICRO = $(get_version_component_range 3);
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
		VERSION=$(get_version_component_range 1-2)
		USE_SYSTEM_LIBFFI=1
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
	java-pkg_doso build/jni/lib${PN}-$(get_version_component_range 1-2)${libname}

	# must by after _doso to have JAVA_PKG_LIBDEST set
	cat > boot.properties <<-EOF
		jffi.boot.library.path = ${JAVA_PKG_LIBDEST}
	EOF
	jar -uf target/${PN}.jar boot.properties || die

	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
