# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-httpclient:commons-httpclient:3.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="The Jakarta Commons HttpClient library"
HOMEPAGE="https://hc.apache.org/httpclient-legacy/"
SRC_URI="mirror://apache/httpcomponents/${PN}/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/httpcomponents/commons-httpclient/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux"

# Tests run: 2036,  Failures: 91
RESTRICT="test"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/httpclient.commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons-httpclient )"
DEPEND="
	dev-java/commons-logging:0
	dev-java/commons-codec:0
	>=virtual/jdk-1.8:*
	test? ( >=dev-java/ant-1.10.14:0[junit] )
"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( NOTICE README RELEASE_NOTES )

JAVA_ENCODING="ISO-8859-1"
JAVA_CLASSPATH_EXTRA="
	commons-logging
	commons-codec
"
JAVA_SRC_DIR="src/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test"

src_prepare() {
	java-pkg-2_src_prepare
	rm -r docs/apidocs || die "clean apidocs"
}

src_install() {
	java-pkg-simple_src_install
	use doc && docinto html dodoc -r docs
}
