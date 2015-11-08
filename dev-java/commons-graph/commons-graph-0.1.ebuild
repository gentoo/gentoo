# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A toolkit for managing graphs and graph based data structures"
HOMEPAGE="https://commons.apache.org/sandbox/commons-graph/"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
	)"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_TEST_TARGET="test"

# Dubious tests.
JAVA_RM_FILES=(
	src/test/java/org/apache/commons/graph/coloring/GraphColoringTestCase.java
	src/test/java/org/apache/commons/graph/spanning/KruskalTestCase.java
	src/test/java/org/apache/commons/graph/scc/TarjanTestCase.java
)

java_prepare() {
	cp "${FILESDIR}"/"${P}-build.xml" build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java
}
