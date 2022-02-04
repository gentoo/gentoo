# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANTLR3="3.5.2"
JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java template engine"
HOMEPAGE="https://www.stringtemplate.org/"
SRC_URI="https://github.com/antlr/${PN}4/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://www.antlr3.org/download/antlr-${ANTLR3}-complete.jar"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
RESTRICT="!test? ( test )"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

# StringTemplate has a cyclic dependency on ANTLR 3. The runtime classes
# are needed at build time and runtime and the tool is also needed at
# build time. To break out of this, we use a prebuilt copy of ANTLR 3 at
# build time and manually register a dependency on the package, which
# will be present at runtime thanks to this PDEPEND. No prebuilt
# software is actually installed onto the system.
PDEPEND=">=dev-java/antlr-${ANTLR3}:3.5"

S="${WORKDIR}/${PN}4-${PV}"
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/antlr-${ANTLR3}-complete.jar"
JAVA_SRC_DIR="src"

PATCHES=(
	# These tests are broken but are probably fixed in current master.
	"${FILESDIR}/4.0.8-r1-test-fixes.patch"
	"${FILESDIR}/${P}-fix-tests.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	default

	# Some of these tests requires a graphical display.
	rm -v test/org/stringtemplate/v4/test/TestEarlyEvaluation.java || die
}

src_compile() {
	java -jar "${JAVA_GENTOO_CLASSPATH_EXTRA}" -lib ${JAVA_SRC_DIR}/org/stringtemplate/v4/compiler $(find ${JAVA_SRC_DIR} -name "*.g") || die
	java-pkg-simple_src_compile
}

src_test() {
	cd test || die
	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars junit-4):${JAVA_GENTOO_CLASSPATH_EXTRA}"

	local TESTS=$(find * -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" $(find -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-dependency antlr-3.5 antlr-runtime.jar
	dodoc {CHANGES,contributors,README}.txt
}
