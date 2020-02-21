# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="A Java template engine"
HOMEPAGE="http://www.stringtemplate.org/"
SRC_URI="https://github.com/antlr/${PN}3/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-java/antlr-2.7.7-r7:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	test? ( >=dev-java/junit-4.11:4 )"

S="${WORKDIR}/${P}"
JAVA_GENTOO_CLASSPATH="antlr"
JAVA_SRC_DIR="src"

java_prepare() {
	# https://github.com/antlr/stringtemplate3/pull/3
	epatch "${FILESDIR}/${PV}-test-fixes.patch"

	java-pkg_clean
}

src_compile() {
	local G; for G in action template angle.bracket.template eval group interface; do # from build.xml
		antlr -o src/org/antlr/stringtemplate/language/{,${G}.g} || die
	done

	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install
	dodoc {CHANGES,README}.txt
}

src_test() {
	cd test || die
	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"

	local TESTS=$(find * -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" $(find -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
