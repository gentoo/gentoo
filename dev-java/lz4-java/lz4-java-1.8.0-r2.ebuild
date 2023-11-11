# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.lz4:lz4-java:1.8.0"

inherit java-pkg-2 java-ant-2 toolchain-funcs

DESCRIPTION="LZ4 compression for Java"
HOMEPAGE="https://github.com/lz4/lz4-java"
SRC_URI="https://github.com/lz4/lz4-java/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Tests require com.carrotsearch.randomizedtesting:junit4-ant, which is yet to
# be packaged.  Some extra steps are required before running the tests:
# 1. Download junit4-ant 2.7.x from https://mvnrepository.com/artifact/com.carrotsearch.randomizedtesting/junit4-ant
# 2. Set EANT_GENTOO_CLASSPATH_EXTRA to the path to junit4-ant-2.7.*.jar
# 3. ppc64 only: Install test dependencies that are unkeyworded
# 4. Set ALLOW_TEST="all"
RESTRICT="test"

CDEPEND="
	app-arch/lz4:=
"

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/mvel:2.5
	dev-libs/xxhash
	test? (
		dev-java/junit:4
		dev-java/randomized-runner:0
	)
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

# Ant is only needed to generate JNI headers;
# the JNI shared object will be built by the custom Makefile
EANT_BUILD_TARGET="compile-java generate-headers"
EANT_DOC_TARGET="docs"
EANT_EXTRA_ARGS="-Djava.io.tmpdir=${T}"
EANT_TEST_GENTOO_CLASSPATH="randomized-runner"

pkg_setup() {
	java-pkg-2_pkg_setup
	local build_only_cp="$(java-pkg_getjars --build-only mvel-2.5)"
	if [[ -z "${EANT_GENTOO_CLASSPATH_EXTRA}" ]]; then
		EANT_GENTOO_CLASSPATH_EXTRA="${build_only_cp}"
	else
		EANT_GENTOO_CLASSPATH_EXTRA+=":${build_only_cp}"
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${P}-print-os-props.patch"
	eapply "${FILESDIR}/${P}-skip-ivy.patch"
	cp "${FILESDIR}/${P}-r1-Makefile" Makefile || die "Failed to copy Makefile"
	cp "${FILESDIR}/${P}-gentoo-classpath.xml" gentoo-classpath.xml ||
		die "Failed to copy Gentoo classpath injection XML"
	java-pkg-2_src_prepare
	rm -r src/resources || die "Failed to remove pre-built shared libraries"
}

src_compile() {
	java-pkg-2_src_compile
	emake CC="$(tc-getCC)" JAVA_HOME="${JAVA_HOME}"
	# JNI has already been built by the Makefile at this point
	# Also pretend cpptasks is available, which is required by build.xml
	EANT_EXTRA_ARGS+=" -Dcpptasks.available=true -Dskip.jni=true"
	# Manually call 'ant jar' to include the JNI shared object in JAR
	eant jar -f "${EANT_BUILD_XML}" ${EANT_EXTRA_ARGS}
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar 'dist/${ivy.module}.jar'
	java-pkg_doso $(find build/jni -name "*.so")
	use doc && java-pkg_dojavadoc build/docs
	# Ant project's 'sources' target generates a source JAR rather than a Zip
	# archive; we simply let java-utils-2.eclass create the source Zip archive
	# from the same source directories the 'sources' target would access
	# https://github.com/lz4/lz4-java/blob/1.8.0/build.xml#L323-L330
	use source && java-pkg_dosrc src/java/* src/java-unsafe/*
}
