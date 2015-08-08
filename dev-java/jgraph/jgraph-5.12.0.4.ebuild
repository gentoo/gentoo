# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Open-source graph component for Java"
SRC_URI="mirror://sourceforge/${PN}/${P}-lgpl-src.jar"
HOMEPAGE="http://www.jgraph.com"
IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"

JAVA_PKG_FILTER_COMPILER="jikes"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.class || die

	# don't do javadoc always
	sed -i -e 's/depends="compile, doc"/depends="compile"/' build.xml || \
		die "sed failed"

	rm -rf doc/api || die
	rm lib/jgraph.jar || die
}

EANT_DOC_TARGET="apidoc"

src_install() {
	java-pkg_dojar build/lib/${PN}.jar

	dodoc README WHATSNEW ChangeLog || die
	use doc && java-pkg_dojavadoc build/doc/api
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples examples
}
