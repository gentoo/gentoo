# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

MY_PV=${PV/_beta/}
MY_P=${PN}-beta-${MY_PV}
DESCRIPTION="UI toolkit for building highly interactive visualizations of structured and unstructured data"
SRC_URI="mirror://sourceforge/prefuse/${MY_P}.zip"
HOMEPAGE="http://prefuse.org"
LICENSE="BSD"
SLOT="2006"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

COMMON_DEP="dev-java/lucene:1"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}
	>=app-arch/unzip-5.50-r1"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S=${WORKDIR}/${PN}-beta

java_prepare() {
	find lib/ -name "*.jar" | xargs rm -v
}

src_compile() {
	java-pkg_filter-compiler jikes
	local targets="prefuse"
	use examples && targets="${targets} demos"
	eant $(use_doc api) ${targets} \
		-Dlucene.lib=$(java-pkg_getjars lucene-1)
}

src_install() {
	java-pkg_dojar build/${PN}.jar

	dodoc readme.txt || die
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples demos/*
}
