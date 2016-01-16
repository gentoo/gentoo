# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

MY_P="${P//-/_}"
MY_P="${MY_P//./_}"

DESCRIPTION="A Java API to read, write, and modify Excel spreadsheets"
HOMEPAGE="http://jexcelapi.sourceforge.net/"
SRC_URI="mirror://sourceforge/jexcelapi/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2.5"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}

	cd "${S}"
	find -name "*.jar" | xargs rm -v
	find -name "*.class" -delete
	rm -fr docs

	# sun-jdk-1.5/jikes fails
	java-pkg_filter-compiler jikes
}

src_compile() {
	eant -f build/build.xml jxl $(use_doc docs)
}

src_install() {
	java-pkg_newjar jxl.jar  ${PN}.jar

	java-pkg_dohtml index.html tutorial.html
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc "${S}"/src/*
}
