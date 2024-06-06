# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.httpcomponents:httpclient:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Apache HttpComponents Client"
HOMEPAGE="https://hc.apache.org/httpcomponents-client-5.2.x/"
SRC_URI="mirror://apache/httpcomponents/httpclient/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/httpcomponents/httpclient/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/httpcomponents-client-${PV}/httpclient"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/httpcomponents-client.hc.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-httpcomponents-client )"

CDEPEND="
	dev-java/commons-codec:0
	dev-java/commons-logging:0
	dev-java/httpcore:0
"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/hamcrest-core:1.3
		dev-java/mockito:0
	)"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{NOTICE,README,RELEASE_NOTES}.txt )

JAVA_GENTOO_CLASSPATH="commons-codec,commons-logging,httpcore"
JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/java-deprecated"
)
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito,hamcrest-core-1.3"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	# Tests run: 929,  Failures: 1
	# javax.net.ssl.SSLHandshakeException: Remote host terminated the handshake
	"org.apache.http.conn.ssl.TestSSLSocketFactory"
)

src_test() {
	# https://bugs.gentoo.org/923602
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "17" ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.net=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
