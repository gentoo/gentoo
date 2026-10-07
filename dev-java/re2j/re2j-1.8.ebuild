# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Linear time regular expressions for Java"
HOMEPAGE="https://github.com/google/re2j"
SRC_URI="https://github.com/google/re2j/archive/refs/tags/re2j-${PV}.tar.gz"
S="${WORKDIR}/re2j-re2j-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/junit:4
		>=dev-java/guava-33.5.0:0
		>=dev-java/truth-1.4.5:0
	)
"

PATCHES=( "${FILESDIR}"/re2j-1.8-skipFailingTests.patch )

RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR=( java ! -path '**/super/**' )
JAVA_TEST_GENTOO_CLASSPATH="guava junit-4 truth"
JAVA_TEST_RESOURCE_DIRS="testdata"
JAVA_TEST_SRC_DIR="javatests"

JAVA_TEST_EXCLUDES=(
	com.google.re2j.GWTTest 		# this test would fail since we do not have GWT
	com.google.re2j.SimplifyTest	# this test runs too long
)

src_install() {
	use source && JAVA_SRC_DIR=( java )
	java-pkg-simple_src_install
}
