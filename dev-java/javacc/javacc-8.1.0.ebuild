# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core module of JavaCC"
HOMEPAGE="https://javacc.github.io/javacc-8/"
SRC_URI="https://github.com/javacc/javacc-8-core/archive/core-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/javacc-8-core-core-${PV}"

LICENSE="BSD-2"
SLOT="8"
KEYWORDS="~amd64 ~arm64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXCLUDES=( org.javacc.JavaCCTestCase ) # This class has no tests
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	"$(java-config -J)" \
		-cp "bootstrap/javacc.jar" org.javacc.jjtree.Main \
		-JJTREE_OUTPUT_DIRECTORY="jjtree-out" \
		src/main/jjtree/JJTree.jjt || die "jjtree"

	"$(java-config -J)" \
		-cp "bootstrap/javacc.jar" org.javacc.parser.Main \
		-OUTPUT_DIRECTORY="jjtree-out" \
		jjtree-out/JJTree.jj || die "parser"

	cp --update=none -v jjtree-out/*.java src/main/java/org/javacc/jjtree || die

	"$(java-config -J)" \
		-cp bootstrap/javacc.jar org.javacc.parser.Main \
		-OUTPUT_DIRECTORY="JavaCC-out" \
		src/main/javacc/JavaCC.jj || die "JavaCC.jj"

	cp --update=none -v JavaCC-out/*.java src/main/java/org/javacc/parser || die

	"$(java-config -J)" \
		-cp bootstrap/javacc.jar org.javacc.parser.Main \
		-OUTPUT_DIRECTORY="ConditionParser-out" \
		src/main/javacc/ConditionParser.jj || die "ConditionParser.jj"

	cp --update=none -v ConditionParser-out/*.java src/main/java/org/javacc/utils || die
}
