# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A barebones WebSocket client and server implementation written in 100% Java"
HOMEPAGE="https://tootallnate.github.io/Java-WebSocket/"
SRC_URI="https://github.com/TooTallNate/Java-WebSocket/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Java-WebSocket-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	dev-java/slf4j-api:0
	>=virtual/jdk-11:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="slf4j-api"
JAVA_INTERMEDIATE_JAR_NAME="org.java_websocket"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/main/java9" )
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY=( org.java_websocket.AllTests )
JAVA_TEST_SRC_DIR="src/test/java"
