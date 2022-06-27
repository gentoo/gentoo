# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Network services database access for java"
HOMEPAGE="https://github.com/jnr/jnr-netdb"
SRC_URI="https://github.com/jnr/jnr-netdb/archive/jnr-netdb-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/jnr-ffi:2"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
