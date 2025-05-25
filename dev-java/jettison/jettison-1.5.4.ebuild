# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.codehaus.jettison:jettison:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A StAX implementation for JSON"
HOMEPAGE="https://github.com/jettison-json/jettison"
SRC_URI="https://github.com/jettison-json/jettison/archive/${P}.tar.gz"
S="${WORKDIR}/jettison-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? ( dev-java/woodstox-core:0 )
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXCLUDES="org.codehaus.jettison.DOMTest"	# "No tests found", not run by maven-bin
JAVA_TEST_GENTOO_CLASSPATH="junit-4,woodstox-core"
JAVA_TEST_SRC_DIR="src/test/java"
