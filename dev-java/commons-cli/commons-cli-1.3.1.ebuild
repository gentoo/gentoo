# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java library for working with the command line arguments and options"
HOMEPAGE="http://commons.apache.org/cli/"
SRC_URI="mirror://apache/commons/cli/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/jre-1.7"

DEPEND=">=virtual/jdk-1.7
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${P}-src"
JAVA_SRC_DIR="src/main/java"

src_install() {
	java-pkg-simple_src_install
	dodoc CONTRIBUTING.md NOTICE.txt README.md RELEASE-NOTES.txt
}

src_test() {
	cd src/test/java || die

	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars junit-4)"
	local TESTS=$(find * -name "*Test.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
