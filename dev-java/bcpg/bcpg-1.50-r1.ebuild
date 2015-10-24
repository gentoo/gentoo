# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-jdk15on-${PV/./}"

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1.50"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"

# Tests are currently broken. Appears to need older version of bcprov; but since bcprov is not slotted, this can cause conflicts.
# Needs further investigation; though, only a small part has tests and there are no tests for bcpg itself.
RESTRICT="test"

CDEPEND="dev-java/bcprov:${SLOT}"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	test? (
		dev-java/ant-junit:0
	)
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_GENTOO_CLASSPATH="bcprov-${SLOT}"

src_unpack() {
	default
	cd "${S}"
	unpack ./src.zip
}

java_prepare() {
	if ! use test; then
		local RM_TEST_FILES=(
			org/bouncycastle/openpgp/test
			org/bouncycastle/openpgp/examples/test
		)
		rm -rf "${RM_TEST_FILES[@]}" || die
	fi
}

src_compile() {
	java-pkg-simple_src_compile
}

src_test() {
	local cp="${PN}.jar:bcprov.jar:junit.jar"
	local pkg="org.bouncycastle"
	java -cp ${cp} ${pkg}.openpgp.test.AllTests | tee openpgp.tests
	grep -q FAILURES *.tests && die "Tests failed."
}

src_install() {
	java-pkg-simple_src_install
	use source && java-pkg_dosrc org
}
