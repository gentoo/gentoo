# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

S=${WORKDIR}/xerces-${PV//./_}
DESCRIPTION="The next generation of high performance, fully compliant XML parsers in the Apache Xerces family"
HOMEPAGE="http://xml.apache.org/xerces2-j/index.html"
SRC_URI="http://archive.apache.org/dist/xml/xerces-j/old_xerces1/Xerces-J-src.${PV}.tar.gz"

LICENSE="Apache-1.1"
SLOT="1.3"
KEYWORDS="amd64 ppc x86"

DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3
	>=dev-java/xalan-2.5.2"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	cp "${FILESDIR}/${P}-build.xml" build.xml || die
}

EANT_DOC_TARGET="docs"

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc README STATUS || die
	dohtml Readme.html || die
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc "${S}/src/org"
}
