# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.bouncycastle:bcpkix-jdk18on:1.71"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="Java APIs for CMS, PKCS, EAC, TSP, CMP, CRMF, OCSP, and certificate generation"
HOMEPAGE="https://www.bouncycastle.org/java.html"
SRC_URI="https://github.com/bcgit/bc-java/archive/r${PV/./rv}.tar.gz -> bc-java-r${PV/./rv}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

# 1) testSANMismatchIP(org.bouncycastle.est.test.TestHostNameAuthorizer)
# org.bouncycastle.est.ESTException: localhost.me: Temporary failure in name resolution HTTP Status Code: 0
PROPERTIES="test_network"
RESTRICT="test"

CDEPEND="
	~dev-java/bcprov-${PV}:0
	~dev-java/bcutil-${PV}:0
	"
DEPEND="${CDEPEND}
	>=virtual/jdk-11:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{README,SECURITY}.md )
HTML_DOCS=( ../{CONTRIBUTORS,index}.html )

S="${WORKDIR}/bc-java-r${PV/./rv}/pkix"

JAVA_GENTOO_CLASSPATH="bcprov,bcutil"
JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/jdk1.9"	# https://bugs.gentoo.org/797634
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXTRA_ARGS="-Dbc.test.data.home=${S}/../core/src/test/data"

# There was 1 failure:
# 1) testSimpleTests(org.bouncycastle.cert.test.AllTests)
# junit.framework.AssertionFailedError: CertTest:
# CertTest: 9 failed - exception java.security.InvalidKeyException: cannot identify EdDSA public key
#         at junit.framework.Assert.fail(Assert.java:57)
#         at junit.framework.TestCase.fail(TestCase.java:223)
#         at org.bouncycastle.cert.test.AllTests.testSimpleTests(AllTests.java:30)
#
# FAILURES!!!
# Tests run: 474,  Failures: 1
JAVA_TEST_RUN_ONLY=(
	"org.bouncycastle.cert.cmp.test.AllTests"
	"org.bouncycastle.cert.crmf.test.AllTests"
	"org.bouncycastle.cert.ocsp.test.AllTests"
	"org.bouncycastle.cert.path.test.AllTests"
#	"org.bouncycastle.cert.test.AllTests"
	"org.bouncycastle.cms.test.AllTests"
	"org.bouncycastle.dvcs.test.AllTests"
	"org.bouncycastle.eac.test.AllTests"
	"org.bouncycastle.est.test.AllTests"
	"org.bouncycastle.mime.test.AllTests"
	"org.bouncycastle.mozilla.test.AllTests"
	"org.bouncycastle.openssl.test.AllTests"
	"org.bouncycastle.operator.test.AllTests"
	"org.bouncycastle.pkcs.test.AllTests"
	"org.bouncycastle.tsp.test.AllTests"
)

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
}

src_prepare() {
	default
	java-pkg_clean ..
}

# https://bugs.gentoo.org/823347
src_test() {
	JAVA_TEST_EXTRA_ARGS+=" -Xmx${CHECKREQS_MEMORY}"
	java-pkg-simple_src_test
}

src_install() {
	default
	einstalldocs
	docinto html
	dodoc -r ../docs
	java-pkg-simple_src_install
}
