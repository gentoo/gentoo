# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.bouncycastle:bcpkix-jdk18on:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="Java APIs for CMS, PKCS, EAC, TSP, CMP, CRMF, OCSP, and certificate generation"
HOMEPAGE="https://www.bouncycastle.org/java.html"
MY_PV="r$(ver_rs 1 'rv' 2 'v')"
SRC_URI="https://github.com/bcgit/bc-java/archive/${MY_PV}.tar.gz -> bc-java-${MY_PV}.tar.gz
	test? ( https://github.com/bcgit/bc-test-data/archive/${MY_PV}.tar.gz -> bc-test-data-${MY_PV}.tar.gz )"
S="${WORKDIR}/bc-java-${MY_PV}/pkix"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"

# 1) testSANMismatchIP(org.bouncycastle.est.test.TestHostNameAuthorizer)
# org.bouncycastle.est.ESTException: localhost.me: Temporary failure in name resolution HTTP Status Code: 0
PROPERTIES="test_network"
RESTRICT="test"

CDEPEND="
	~dev-java/bcprov-${PV}:0
	~dev-java/bcutil-${PV}:0
"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-11:*
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( ../{README,SECURITY}.md )
HTML_DOCS=( ../{CONTRIBUTORS,index}.html )

JAVA_AUTOMATIC_MODULE_NAME="org.bouncycastle.pkix"
JAVA_GENTOO_CLASSPATH="bcprov,bcutil"
JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/jdk1.9"
)

JAVA_TEST_EXTRA_ARGS="-Dbc.test.data.home=${S}/../core/src/test/data"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
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

# https://bugs.gentoo.org/823347
src_test() {
	mv ../../bc-test-data-${MY_PV} bc-test-data || die "cannot move bc-test-data"

	JAVA_TEST_EXTRA_ARGS+=" -Xmx${CHECKREQS_MEMORY}"
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
		-name "AllTests.java" \
		)
	popd
	einfo "${JAVA_TEST_RUN_ONLY}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

src_install() {
	docinto html
	dodoc -r ../docs
	java-pkg-simple_src_install
}
