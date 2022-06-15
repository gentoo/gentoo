# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.java.dev.jna:jna:5.10.0"

inherit java-pkg-2 java-ant-2 toolchain-funcs

DESCRIPTION="Java Native Access"
HOMEPAGE="https://github.com/java-native-access/jna"
SRC_URI="https://github.com/java-native-access/jna/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-2.1+ )"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~x86"

BDEPEND="
	virtual/pkgconfig
"

CDEPEND="
	>=dev-libs/libffi-3.4:=
"

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/animal-sniffer-annotations:0
	dev-java/ant-core:0
	dev-java/asm:9
	test? (
		dev-java/ant-junit4:0
		dev-java/junit:4
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
	"${FILESDIR}/${PV}-build.xml.patch"
	"${FILESDIR}/4.2.2-makefile-flags.patch"
)

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_PKG_BSFIX_NAME="build.xml build-ant-tools.xml"
EANT_BUILD_TARGET="jar contrib-jars"
EANT_EXTRA_ARGS="-Dbuild-native=true -Dcompatibility=1.8 -Ddynlink.native=true"
EANT_TEST_EXTRA_ARGS="-Djava.io.tmpdir=\"${T}\""
EANT_TEST_GENTOO_CLASSPATH="animal-sniffer-annotations,reflections"

pkg_setup() {
	java-pkg-2_pkg_setup

	EANT_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only \
		animal-sniffer-annotations,ant-core,asm-9)"

	# Any spaces in paths returned by toolchain-funcs and options like MAKEOPTS
	# could cause trouble in EANT_EXTRA_ARGS when Java eclasses process the
	# variable's value, so define them in ANT_OPTS instead
	ANT_OPTS="-DCC='$(tc-getCC)'"
	# Parallel build does not respect dependency relationships between objects
	ANT_OPTS+=" -DEXTRA_MAKE_OPTS='${MAKEOPTS} -j1'"
}

src_prepare() {
	default

	# Eliminate build.xml's dependency on bundled native JARs
	sed -i -e '/zipfileset src="${lib.native}/,+2d' build.xml ||
		die "Failed to delete lines referencing bundled JARs in build.xml"

	# Clean up bundled JARs and libffi
	java-pkg_clean
	rm -r native/libffi || die "Failed to remove bundled libffi"

	java-pkg-2_src_prepare
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "build/${PN}-min.jar"
	java-pkg_dojar "contrib/platform/dist/${PN}-platform.jar"
	java-pkg_doso build/native-*/libjnidispatch.so
	einstalldocs

	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc doc/javadoc
}
