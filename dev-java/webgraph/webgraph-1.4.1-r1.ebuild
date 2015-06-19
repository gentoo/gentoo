# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/webgraph/webgraph-1.4.1-r1.ebuild,v 1.4 2014/08/10 20:26:22 slyfox Exp $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="WebGraph is a framework to study the web graph"
SRC_URI="http://webgraph.dsi.unimi.it/${P}-src.tar.gz"
HOMEPAGE="http://webgraph.dsi.unimi.it"
LICENSE="LGPL-2.1"
SLOT="1.4"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

COMMON_DEP="=dev-java/java-getopt-1.0*
	=dev-java/fastutil-4.4*
	=dev-java/colt-1*
	>=dev-java/jal-20031117
	=dev-java/mg4j-0.9*"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

src_unpack() {

	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"

	mkdir lib/ && cd lib/
	java-pkg_jar-from java-getopt-1
	java-pkg_jar-from fastutil-4.4
	java-pkg_jar-from colt colt.jar
	java-pkg_jar-from jal jal.jar
	java-pkg_jar-from mg4j-0.9

}

src_install() {

	java-pkg_newjar ${P}.jar ${PN}.jar

	dodoc CHANGES

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc java/it

}
