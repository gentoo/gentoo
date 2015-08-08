# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Simple Java toolkit for JSON"
HOMEPAGE="http://www.json.org"

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}-all"
SRC_URI="http://json-simple.googlecode.com/files/${MY_P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	epatch "${FILESDIR}/${P}-extra-constructors-from-azureus.patch"
	rm -rv build lib || die
}

#JAVA_ANT_ENCODING="ISO-8859-1"
#EANT_BUILD_TARGET="dist"

JAVA_PKG_BSFIX_NAME+=" test.xml"

src_test() {
	java-pkg_jar-from --into lib junit
	ANT_TASKS="ant-junit" eant -f test.xml
}

src_install() {
	java-pkg_newjar lib/${MY_P/-all/}.jar ${PN}.jar
	dodoc README.txt AUTHORS.txt ChangeLog.txt || die
	use source && java-pkg_dosrc src/org
}
