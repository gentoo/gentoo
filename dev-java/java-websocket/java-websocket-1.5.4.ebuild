# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID=""
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A barebones WebSocket client and server implementation written in 100% Java"
HOMEPAGE="https://tootallnate.github.io/Java-WebSocket/"
SRC_URI="https://github.com/TooTallNate/Java-WebSocket/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Java-WebSocket-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="dev-java/slf4j-api:0"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/json:0
		dev-java/slf4j-simple:0
	)"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( CHANGELOG.md README.markdown )

PATCHES=(
	"${FILESDIR}/java-websocket-1.5.4-AllIssueTests.patch"
	"${FILESDIR}/java-websocket-1.5.4-Issue764Test.patch"
	"${FILESDIR}/java-websocket-1.5.4-Issue825Test.patch"
)

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	json
	junit-4
	slf4j-simple
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	default
}

src_test() {
	JAVA_TEST_RUN_ONLY=(
		org.java_websocket.AllTests
	)
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY=(
		org.java_websocket.issues.Issue764Test
	#	org.java_websocket.issues.Issue825Test
		org.java_websocket.issues.Issue834Test
	)
	java-pkg-simple_src_test
}
