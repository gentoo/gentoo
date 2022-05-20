# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Command line parsing framework for Java"
HOMEPAGE="https://github.com/cbeust/jcommander"
SRC_URI="https://github.com/cbeust/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? ( dev-java/jackson-annotations:2 )
"
RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"

# ===============================================
# Command line suite
# Total tests run: 258, Failures: 3, Skips: 0
# ===============================================
#
#  * ERROR: dev-java/jcommander-1.82::gentoo failed (test phase):
#  *   Running TestNG failed.

# https://bugs.gentoo.org/801694
# Needs "java-util-2-runner-args.patch" from https://github.com/gentoo/gentoo/pull/21319#issuecomment-878128343
JAVA_TEST_RUNNER_EXTRA_ARGS=( -verbose 3 -usedefaultlisteners true )

JAVA_TEST_GENTOO_CLASSPATH="jackson-annotations-2,testng"
JAVA_TEST_EXTRA_ARGS=( -Djava.io.tmpdir="${T}" )
JAVA_TEST_SRC_DIR=( src/test/java )
JAVA_TEST_RESOURCE_DIRS=( src/test/resources )

src_prepare() {
	default
	java-pkg_clean
}

src_test() {
	# because module java.base does not export sun.reflect.annotation to unnamed module @0x42bb2aee
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/sun.reflect.annotation=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
