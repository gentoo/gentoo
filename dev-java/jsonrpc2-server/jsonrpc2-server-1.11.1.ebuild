# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.thetransactioncompany:jsonrpc2-server:1.11.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Server framework for processing JSON-RPC 2.0 messages"
HOMEPAGE="https://software.dzhuvinov.com/json-rpc-2.0-server.html"
SRC_URI="https://bitbucket.org/thetransactioncompany/json-rpc-2.0-server/get/${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/thetransactioncompany-json-rpc-2.0-server-40234a8c2029"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ~arm64"

PROPERTIES="test_network"
RESTRICT="test" # single test, need access to google

CP_DEPEND="
	dev-java/jsonrpc2-base:1
	dev-java/json-smart:1
"

DEPEND="
	${CP_DEPEND}
	dev-java/javax-servlet-api:3.0
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="javax-servlet-api-3.0"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"

src_prepare() {
	default

	rm -r src/main/java/com/thetransactioncompany/jsonrpc2/server/examples ||
		die 'rm example codes'
}
