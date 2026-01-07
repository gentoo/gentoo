# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="org.bouncycastle:bcpg-jdk18on:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="https://www.bouncycastle.org/download/bouncy-castle-java/"
MY_PV="r$(ver_rs 1 'rv' 2 'v')"
SRC_URI="https://github.com/bcgit/bc-java/archive/${MY_PV}.tar.gz -> bc-java-${MY_PV}.tar.gz"
S="${WORKDIR}/bc-java-${MY_PV}/pg"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

CP_DEPEND="
	~dev-java/bcprov-${PV}:0
	~dev-java/bcutil-${PV}:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( ../{README,SECURITY}.md )
HTML_DOCS=( ../{CONTRIBUTORS,index}.html )

JAVA_AUTOMATIC_MODULE_NAME="org.bouncycastle.pg"
JAVA_SRC_DIR=( src/main/{java,jdk1.9} )
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean ..
}

src_test() {
	local TESTS=$(find src/test/java -name 'AllTests.java' -printf '%P\n' )
	TESTS="${TESTS//.java}"
	JAVA_TEST_RUN_ONLY="${TESTS//\//.}"
	java-pkg-simple_src_test
}

src_install() {
	docinto html
	dodoc -r ../docs
	java-pkg-simple_src_install
}
