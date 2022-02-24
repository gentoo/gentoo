# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.antlr:ST4:4.3.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java template engine"
HOMEPAGE="https://www.stringtemplate.org/"
# Maven Central sources JAR for *.java sources pre-generated from *.g files;
# the source generation requires antlr-tool-3.5, which depends on this package.
# Tarball for the test suite and DOCS files
SRC_URI="
	https://repo1.maven.org/maven2/org/antlr/ST4/${PV}/ST4-${PV}-sources.jar
	https://github.com/antlr/${PN}4/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

CP_DEPEND="
	dev-java/antlr-runtime:3.5
"

BDEPEND="
	app-arch/unzip
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/antlr-tool:3.5
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}"
TARBALL_S="${S}/${PN}4-${PV}"

JAVA_SRC_DIR="org"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,antlr-tool-3.5"
JAVA_TEST_SRC_DIR="${TARBALL_S}/test"

DOCS=( "${TARBALL_S}/"{CHANGES.txt,contributors.txt,README.md} )

src_prepare() {
	java-pkg_clean # Just in case Maven Central sources JAR contains binary
	if use test; then
		pushd "${TARBALL_S}" > /dev/null ||
			die "Failed to enter directory storing tarball contents"
		eapply "${FILESDIR}/${P}-BaseTest-javac-source-target.patch"
		popd > /dev/null ||
			die "Failed to leave directory storing tarball contents"
	fi
	java-pkg-2_src_prepare
	# Some of these tests requires a graphical display.
	rm -v "${JAVA_TEST_SRC_DIR}/org/stringtemplate/v4/test/TestEarlyEvaluation.java" || die
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
