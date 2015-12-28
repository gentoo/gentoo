# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2 versionator

DESCRIPTION="An optimized Java interface to libffi"
HOMEPAGE="https://github.com/jnr"
SRC_URI="https://github.com/jnr/jffi/tarball/${PV} -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-3 )"
SLOT="1.0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

CDEPEND="
	virtual/libffi"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	virtual/pkgconfig
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)"

PATCHES=(
	"${FILESDIR}"/${P}_no-werror.patch
)

src_unpack() {
	unpack ${A}
	mv jnr-jffi-* "${P}" || die
}

java_prepare() {
	java-pkg_clean

	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die

	epatch "${PATCHES[@]}"

	sed -i -e 's/-Werror //' libtest/GNUmakefile || die

	# Fix build with GCC 4.7 #421501
	sed -i -e "s|-mimpure-text||g" jni/GNUmakefile libtest/GNUmakefile || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

src_compile() {
	# generate Version.java
	cat <<-EOF > src/main/java/com/kenai/jffi/Version.java
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
	mkdir -p build/jni || die
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

EANT_TEST_GENTOO_CLASSPATH="junit-4"
src_test() {
	# build native test library
	emake BUILD_DIR=build -f libtest/GNUmakefile

	_JAVA_OPTIONS="-Djffi.boot.library.path=build/jni" \
		java-pkg-2_src_test
}

src_install() {
	java-pkg_doso build/jni/lib${PN}-$(get_version_component_range 1-2).so

	# must by after _doso to have JAVA_PKG_LIBDEST set
	cat <<-EOF > boot.properties
		jffi.boot.library.path = ${JAVA_PKG_LIBDEST}
	EOF
	jar -uf target/${PN}.jar boot.properties || die

	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
