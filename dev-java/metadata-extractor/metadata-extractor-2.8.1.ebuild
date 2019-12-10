# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Access the metadata in digital images and video via a simple Java API"
HOMEPAGE="http://www.drewnoakes.com/code/exif/"
SRC_URI="https://github.com/drewnoakes/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

CDEPEND="dev-java/xmpcore:0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	test? ( dev-java/junit:4 )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="Source"
JAVA_GENTOO_CLASSPATH="xmpcore"

java_prepare() {
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	dodoc {CONTRIBUTING,README}.md
	use examples && java-pkg_doexamples Samples
}

src_test() {
	local DIR=Tests
	local CP="${DIR}:${S}/${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find ${DIR} -name "*Test.java")
	TESTS="${TESTS//Tests\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
