# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.bouncycastle:bcpkix-jdk15on:1.69"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java APIs for CMS, PKCS, EAC, TSP, CMP, CRMF, OCSP, and certificate generation"
HOMEPAGE="https://www.bouncycastle.org/java.html"
SRC_URI="https://github.com/bcgit/bc-java/archive/refs/tags/r${PV/./rv}.tar.gz -> bc-java-r${PV/./rv}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"

CDEPEND="
	~dev-java/bcprov-${PV}:0
	~dev-java/bcutil-${PV}:0
	"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{README,SECURITY}.md )
HTML_DOCS=( ../{CONTRIBUTORS,index,LICENSE}.html )

S="${WORKDIR}/bc-java-r${PV/./rv}/pkix"

JAVA_GENTOO_CLASSPATH="bcprov,bcutil"
JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/jdk1.9"	# https://bugs.gentoo.org/797634
)
#	JAVA_RESOURCE_DIRS="src/main/resources"	# Does not exist

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXTRA_ARGS="-Dbc.test.data.home=${S}/../core/src/test/data"

JAVA_TEST_RUN_ONLY=(
	"org.bouncycastle.cert.cmp.test.AllTests"
	"org.bouncycastle.cert.crmf.test.AllTests"
	"org.bouncycastle.cert.ocsp.test.AllTests"
	"org.bouncycastle.cert.path.test.AllTests"
	"org.bouncycastle.cert.test.AllTests"
	"org.bouncycastle.cms.test.AllTests"
	"org.bouncycastle.dvcs.test.AllTests"
	"org.bouncycastle.eac.test.AllTests"
#	"org.bouncycastle.est.test.AllTests" # (16 tests) org.bouncycastle.est.ESTException: localhost.me: Temporary failure in name resolution HTTP Status Code: 0
	"org.bouncycastle.mime.test.AllTests"
	"org.bouncycastle.mozilla.test.AllTests"
	"org.bouncycastle.openssl.test.AllTests"
	"org.bouncycastle.operator.test.AllTests"
	"org.bouncycastle.pkcs.test.AllTests"
	"org.bouncycastle.tsp.test.AllTests"
)

src_prepare() {
	default
	cd ../ || die
	java-pkg_clean
}

src_install() {
	default
	einstalldocs
	docinto html
	dodoc -r ../docs
	java-pkg-simple_src_install
}
