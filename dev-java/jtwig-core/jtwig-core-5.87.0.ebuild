# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jtwig:jtwig-core:${PV}.RELEASE"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jtwig Reflection Library"
HOMEPAGE="https://github.com/jtwig/jtwig-core"
SRC_URI="https://github.com/jtwig/jtwig-core/archive/${PV}.RELEASE.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}.RELEASE"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
# no tests because
# net.jperf does not exist
# org.unitils.reflectionassert does not exist
RESTRICT="test"

DEPEND="
	dev-java/commons-lang:3.6
	dev-java/concurrentlinkedhashmap-lru:0
	dev-java/guava:0
	dev-java/jtwig-reflection:0
	dev-java/parboiled:0
	dev-java/slf4j-api:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/commons-io:1
		dev-java/commons-lang:3.6
		dev-java/hamcrest:0
		dev-java/mockito:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="
	commons-lang-3.6
	concurrentlinkedhashmap-lru
	guava
	jtwig-reflection
	parboiled
	slf4j-api
"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	commons-io-1
	commons-lang-3.6
	hamcrest
	junit-4
	mockito
"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
