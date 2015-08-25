# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="source test doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="http://www.jdom.org/dist/binary/${P}.zip"
HOMEPAGE="http://www.jdom.org"
LICENSE="JDOM"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

CDEPEND="dev-java/iso-relax:0
	dev-java/jaxen:1.1
	dev-java/xalan:0
	dev-java/junit:4
	dev-java/xml-commons-external:1.4"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"
DEPEND="${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"
IUSE=""

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="xalan,junit-4,jaxen-1.1,iso-relax,xml-commons-external-1.4"
JAVA_SRC_DIR="org"

src_unpack() {
	default
	cd "${S}"
	unpack ./"${P}-sources".jar
}

java_prepare() {
	find "${S}"/lib -type f -delete || die
}

src_compile() {
	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install
	use source && java-pkg_dosrc org
}

src_test() {
	local DIR="org/jdom2/test"
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"

	local TESTS=$(find "${DIR}" -name "*Test.java" ! -name "Abstract*")
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" -d "${DIR}" $(find "${DIR}" -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
