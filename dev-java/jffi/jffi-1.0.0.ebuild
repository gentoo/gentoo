# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jffi/jffi-1.0.0.ebuild,v 1.8 2012/08/25 19:09:47 thev00d00 Exp $

# Probably best to leave the CFLAGS as they are here. See...
# http://weblogs.java.net/blog/kellyohair/archive/2006/01/compilation_of_1.html

EAPI="2"
JAVA_PKG_IUSE="source test"
WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2 toolchain-funcs flag-o-matic versionator

DESCRIPTION="An optimized Java interface to libffi"
HOMEPAGE="http://github.com/wmeissner/jffi"

SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0.4"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	virtual/libffi"

DEPEND=">=virtual/jdk-1.5
	virtual/libffi
	virtual/pkgconfig
	test? ( dev-java/ant-junit4 )"

JAVA_PKG_BSFIX_NAME="build-impl.xml custom-build.xml"
JAVA_PKG_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5"

java_prepare() {
	# Delete the bundled JARs.
	find lib archive -name "*.jar" -delete || die
	# Delete the bundled libffi
	rm -rf jni/libffi || die

	epatch "${FILESDIR}/${P}-makefile.patch"
	epatch "${FILESDIR}/1.0.0-gcc-3.4.patch"

	# any better function for this, excluding get_system_arch in java-vm-2 which is incorrect to inherit ?
	local arch=""
	use x86 && arch="i386"
	use amd64 && arch="x86_64"
	use ppc && arch="ppc"

	# Don't include prebuilt files for other archs.
	sed -i '/<zipfileset src="archive\//d' custom-build.xml || die
	sed -i '/libs.CopyLibs.classpath/d' lib/nblibraries.properties || die
	sed -i '/copylibstask.jar/d' lib/nblibraries.properties || die

	# Fix build with GCC 4.7 #421501
	sed -i -e "s|-mimpure-text||g" jni/GNUmakefile || die
}

EANT_EXTRA_ARGS="-Duse.system.libffi=1"

src_install() {
	mkdir -p "${T}"/com/kenai/jffi
	cat - > "${T}"/com/kenai/jffi/boot.properties <<EOF
jffi.boot.library.path = ${JAVA_PKG_LIBDEST}
EOF

	pushd "${T}" &>/dev/null
	jar -uf "${S}"/dist/${PN}.jar com
	popd

	java-pkg_dojar dist/${PN}.jar
	java-pkg_doso build/jni/lib${PN}-$(get_version_component_range 1-2).so
	use source && java-pkg_dosrc src/*
}

src_test() {
	ANT_TASKS="ant-junit4 ant-nodeps" eant test \
		"${EANT_EXTRA_ARGS}" \
		-Dlibs.junit_4.classpath="$(java-pkg_getjars --with-dependencies junit-4)"
}
