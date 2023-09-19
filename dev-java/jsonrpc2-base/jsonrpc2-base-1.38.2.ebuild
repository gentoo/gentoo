# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.thetransactioncompany:jsonrpc2-base:1.38.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Represent, parse and serialise JSON-RPC 2.0 messages"
HOMEPAGE="https://software.dzhuvinov.com/json-rpc-2.0-base.html"
SRC_URI="https://bitbucket.org/thetransactioncompany/json-rpc-2.0-base/get/${PV}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

CP_DEPEND="dev-java/json-smart:1"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/thetransactioncompany-json-rpc-2.0-base-75e66af02953"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_EXCLUDES=( "com.thetransactioncompany.jsonrpc2.util.TestEnumDay" )
