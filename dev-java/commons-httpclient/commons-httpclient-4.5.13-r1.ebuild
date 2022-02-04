# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom httpcomponents-client-4.5.13/httpclient/pom.xml --download-uri https://github.com/apache/httpcomponents-client/archive/refs/tags/rel/v4.5.13.tar.gz --slot 4 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-httpclient-4.5.13.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.httpcomponents:httpclient:4.5.13"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache HttpComponents Client"
HOMEPAGE="https://hc.apache.org/httpcomponents-client"
SRC_URI="mirror://apache/httpcomponents/httpclient/source/httpcomponents-client-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

# Common dependencies
# POM: httpcomponents-client-${PV}/httpclient/pom.xml
# commons-codec:commons-codec:1.11 -> >=dev-java/commons-codec-1.15:0
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0
# org.apache.httpcomponents:httpcore:4.4.13 -> >=dev-java/httpcore-4.4.14:0

CDEPEND="
	dev-java/commons-codec:0
	dev-java/commons-logging:0
	dev-java/httpcore:0
"

# Compile dependencies
# POM: httpcomponents-client-${PV}/httpclient/pom.xml
# test? junit:junit:4.11 -> >=dev-java/junit-4.13.2:4
# test? org.mockito:mockito-core:1.10.19 -> >=dev-java/mockito-1.9.5:0

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/hamcrest-core:1.3
		dev-java/mockito:0
	)"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{LICENSE,NOTICE,README,RELEASE_NOTES}.txt )

S="${WORKDIR}/httpcomponents-client-${PV}/httpclient"

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

src_install() {
	default
	java-pkg-simple_src_install
}
