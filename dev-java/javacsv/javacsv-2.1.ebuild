# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

RESTRICT="test"

DESCRIPTION="Java library for reading and writing CSV and plain delimited text files"
HOMEPAGE="http://www.csvreader.com/java_csv.php"
SRC_URI="mirror://sourceforge/${PN}/${P/-/}.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

java_prepare() {
	rm -rfv doc "${PN}".jar || die "error cleaning up"
	mv -v src/AllTests.java . || die "error moving tests"
}

EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET=""

src_compile() {
	java-pkg-2_src_compile
	use doc && eant -f "${S}"/javadoc.xml
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src
}
