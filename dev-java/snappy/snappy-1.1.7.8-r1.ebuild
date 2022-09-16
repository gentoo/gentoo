# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.xerial.snappy:snappy-java:1.1.7.8"

inherit java-pkg-2 java-ant-2 toolchain-funcs

MY_PN="${PN}-java"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Snappy compressor/decompressor for Java"
HOMEPAGE="https://github.com/xerial/snappy-java/"
SRC_URI="https://github.com/xerial/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Tests require org.apache.hadoop:hadoop-common:2.7.*, which is yet to be
# packaged.  Some extra steps are required before running the tests:
# 1. Download hadoop-common 2.7.x from https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-common
# 2. Set EANT_GENTOO_CLASSPATH_EXTRA to the path to hadoop-common-2.7.*.jar
# 3. Set ALLOW_TEST="all"
RESTRICT="test"

CDEPEND="dev-java/osgi-core:0
	app-arch/snappy
	dev-libs/bitshuffle"

DEPEND=">=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		dev-java/ant-junit4:0
		dev-java/commons-io:1
		dev-java/commons-lang:2.1
		dev-java/plexus-classworlds:0
		dev-java/xerial-core:0
	)"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_CLASSPATH_TAGS="javac javadoc"
EANT_GENTOO_CLASSPATH="osgi-core"
EANT_TEST_GENTOO_CLASSPATH="
	${EANT_GENTOO_CLASSPATH}
	commons-io-1
	commons-lang-2.1
	plexus-classworlds
	xerial-core
"

src_prepare() {
	cp "${FILESDIR}/1.x-build.xml" build.xml || die
	rm -r src/main/resources/org/xerial/snappy/native || die
	eapply "${FILESDIR}/${PV}-java-version-target.patch"
	eapply "${FILESDIR}/${PV}-remove-perl-usage.patch"
	eapply "${FILESDIR}/${PV}-unbundle-snappy.patch"
	eapply "${FILESDIR}/${PV}-unbundle-bitshuffle.patch"
	eapply "${FILESDIR}/${PV}-gentoo.patch"
	java-pkg-2_src_prepare
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		JAVA_SOURCE="$(java-pkg_get-source)" \
		JAVA_TARGET="$(java-pkg_get-target)"
	java-pkg-2_src_compile
}

src_test() {
	cp -r src/test/resources/org/xerial/snappy/* \
		src/test/java/org/xerial/snappy || die
	java-pkg-2_src_test
}

src_install() {
	local jniext=.so
	if [[ ${CHOST} == *-darwin* ]] ; then
		jniext=.jnilib
		# avoid install_name check failure
		install_name_tool -id "@loader_path/libsnappyjava${jniext}" \
			"target/libsnappyjava${jniext}"
	fi
	java-pkg_doso "target/libsnappyjava${jniext}"
	java-pkg_dojar "target/${PN}.jar"

	use source && java-pkg_dosrc src/main/java/*
	use doc && java-pkg_dojavadoc target/site/apidocs
}
