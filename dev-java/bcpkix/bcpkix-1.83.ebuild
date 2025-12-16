# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="org.bouncycastle:bcpkix-jdk18on:${PV}"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="Java APIs for CMS, PKCS, EAC, TSP, CMP, CRMF, OCSP, and certificate generation"
HOMEPAGE="https://www.bouncycastle.org/download/bouncy-castle-java/"
MY_PV="r$(ver_rs 1 'rv' 2 'v')"
SRC_URI="https://github.com/bcgit/bc-java/archive/${MY_PV}.tar.gz -> bc-java-${MY_PV}.tar.gz
	test? ( https://github.com/bcgit/bc-test-data/archive/${MY_PV}.tar.gz -> bc-test-data-${MY_PV}.tar.gz )"
S="${WORKDIR}/bc-java-${MY_PV}/pkix"

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

JAVA_AUTOMATIC_MODULE_NAME="org.bouncycastle.pkix"
JAVA_SRC_DIR=( src/main/{java,jdk1.9} )
JAVA_TEST_EXTRA_ARGS="-Dbc.test.data.home=${S}/../core/src/test/data"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS=( src/{main,test}/resources )
JAVA_TEST_SRC_DIR="src/test/java"

# https://bugs.gentoo.org/823347
check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="2048M"
		check-reqs_pkg_pretend
	fi
}

# https://bugs.gentoo.org/823347
pkg_pretend() {
	check_env
}

# https://bugs.gentoo.org/823347
pkg_setup() {
	check_env
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack bc-java-${MY_PV}.tar.gz
	use test && unpack bc-test-data-${MY_PV}.tar.gz
}

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean ..
}

src_test() {
	mv ../../bc-test-data-${MY_PV} bc-test-data || die "cannot move bc-test-data"

	# https://bugs.gentoo.org/823347
	JAVA_TEST_EXTRA_ARGS+=" -Xmx${CHECKREQS_MEMORY}"

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
