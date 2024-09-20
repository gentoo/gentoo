# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Artifact ID for antlr-tool is 'antlr'
# https://github.com/antlr/antlr3/blob/3.5.3/tool/pom.xml#L4
MAVEN_ID="org.antlr:antlr:3.5.3"

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN%-tool}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The ANTLR 3 tool"
HOMEPAGE="https://www.antlr3.org/"
# Maven Central sources JAR for *.java sources pre-generated from *.g files;
# the source generation requires this package itself.
# Tarball for resources, the test suite, and DOCS files
SRC_URI="
	https://repo1.maven.org/maven2/org/antlr/antlr/${PV}/${MY_P}-sources.jar -> ${P}-sources.jar
	https://github.com/antlr/antlr3/archive/${PV}.tar.gz -> ${MY_P}.tar.gz
"

LICENSE="BSD"
SLOT="3.5"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

CP_DEPEND="
	~dev-java/antlr-runtime-${PV}:${SLOT}
	dev-java/stringtemplate:4
"

BDEPEND="
	app-arch/unzip
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

TARBALL_S="${S}/${MY_PN}3-${PV}"

JAVA_SRC_DIR="org"
JAVA_RESOURCE_DIRS=( "${TARBALL_S}/tool/src/main/resources" )

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="${TARBALL_S}/tool/src/test/java"

DOCS=( "${TARBALL_S}/tool/CHANGES.txt" )
PATCHES=( "${FILESDIR}/antlr-tool-3.5.3-java21.patch" )

src_prepare() {
	java-pkg_clean
	default #780585
	java-pkg-2_src_prepare

	# Some tests fail under Java 8 in ways that probably aren't limited
	# to the tests. This is bad but upstream is never going to update
	# 3.5. At the time of writing, we only use it to build 4 anyway.
	rm -v "${JAVA_TEST_SRC_DIR}/org/antlr/test/"Test{DFAConversion,SemanticPredicates,TopologicalSort}.java || die
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
