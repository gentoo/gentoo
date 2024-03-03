# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.xerial.snappy:snappy-java:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple toolchain-funcs check-reqs

DESCRIPTION="Snappy compressor/decompressor for Java"
HOMEPAGE="https://github.com/xerial/snappy-java/"
# ::gentoo does not have hadoop-common packaged. Currently we bundle the binary version.
# It's used for testing only and does not get installed.
HCV="3.3.5"
SRC_URI="https://github.com/xerial/snappy-java/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/${HCV}/hadoop-common-${HCV}.jar )"
S="${WORKDIR}/snappy-java-${PV}"

LICENSE="Apache-2.0"
SLOT="1.1"
KEYWORDS="amd64 ~arm arm64 ppc64 ~x86"

CP_DEPEND="dev-java/osgi-core:0"

CDEPEND="
	app-arch/snappy
	dev-libs/bitshuffle
"

DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}
	${CDEPEND}
	test? (
		>=dev-java/ant-1.10.14:0[junit4]
		dev-java/commons-io:1
		dev-java/commons-lang:3.6
		dev-java/plexus-classworlds:0
		dev-java/xerial-core:0
	)"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}
	${CDEPEND}"

PATCHES=(
	"${FILESDIR}/1.1.7.8-java-version-target.patch"
	"${FILESDIR}/snappy-1.1.10.1-unbundle-snappy.patch"
	"${FILESDIR}/1.1.7.8-unbundle-bitshuffle.patch"
	"${FILESDIR}/1.1.7.8-gentoo.patch"
	"${FILESDIR}/snappy-1.1.10.5-SnappyOutputStreamTest.patch"
	"${FILESDIR}/snappy-1.1.10.1-commons-lang3.patch"
)

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	commons-io-1
	commons-lang-3.6
	junit-4
	plexus-classworlds
	xerial-core
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="2560M"
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_env
}

pkg_setup() {
	check_env
	java-pkg-2_pkg_setup
}

src_prepare() {
	default
	java-pkg-2_src_prepare
	# remove pre-compiled sofiles
	rm -r src/main/resources/org/xerial/snappy/native || die
	rm -r src/test/resources/lib || die
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		JAVA_SOURCE="$(java-pkg_get-source)" \
		JAVA_TARGET="$(java-pkg_get-target)"

	java-pkg-simple_src_compile
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/hadoop-common-${HCV}.jar"
	JAVA_TEST_EXTRA_ARGS=( -Xmx${CHECKREQS_MEMORY} )
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		java-pkg-simple_src_test
	else
		einfo "Tests need jdk-17 to pass."
	fi
}

src_install() {
	java-pkg-simple_src_install

	local jniext=.so
	if [[ ${CHOST} == *-darwin* ]] ; then
		jniext=.jnilib
		# avoid install_name check failure
		install_name_tool -id "@loader_path/libsnappyjava${jniext}" \
			"target/libsnappyjava${jniext}"
	fi
	java-pkg_doso "target/libsnappyjava${jniext}"
}
