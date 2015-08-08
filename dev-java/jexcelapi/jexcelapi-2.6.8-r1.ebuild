# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="${P//-/_}"
MY_P="${MY_P//./_}"

DESCRIPTION="A Java API to read, write, and modify Excel spreadsheets"
HOMEPAGE="http://jexcelapi.sourceforge.net/"
SRC_URI="mirror://sourceforge/jexcelapi/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2.5"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${PN}

EANT_BUILD_XML="build/build.xml"
EANT_FILTER_COMPILER="jikes"
EANT_BUILD_TARGET="jxl"
EANT_DOC_TARGET="docs"

java_prepare() {
	find "${S}" -name "*.jar" -o -name "*.class" -delete || die
}

src_install() {
	java-pkg_newjar jxl.jar  ${PN}.jar

	java-pkg_dohtml index.html tutorial.html
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc "${S}"/src/*
}
