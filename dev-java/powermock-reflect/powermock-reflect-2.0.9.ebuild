# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Various utilities for accessing internals of a class"
HOMEPAGE="https://github.com/powermock/powermock"
SRC_URI="https://github.com/powermock/powermock/archive/powermock-${PV}.tar.gz"
S="${WORKDIR}/powermock-powermock-${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=">=dev-java/objenesis-3.4:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/asm-9.9.1:0
		>=dev-java/assertj-core-3.27.6:0
		>=dev-java/byte-buddy-1.18.2:0
		>=dev-java/cglib-3.3.0-r3:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

PATCHES=(
	"${FILESDIR}/powermock-reflect-2.0.9-ClassFactory.patch"
	"${FILESDIR}/powermock-reflect-2.0.9-WhiteBoxTest.patch"
)

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm assertj-core byte-buddy cglib junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS=( --add-opens=java.base/java.lang=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
