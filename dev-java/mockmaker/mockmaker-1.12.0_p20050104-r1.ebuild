# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mockmaker/mockmaker-1.12.0_p20050104-r1.ebuild,v 1.9 2014/08/10 20:21:38 slyfox Exp $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Program for automatically creating source code for mock object"
HOMEPAGE="http://mockmaker.sourceforge.net"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="MIT"
SLOT="1.12"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	dev-java/qdox
	=dev-java/junit-3.8*
	>=dev-java/ant-core-1.4
	dev-java/mockobjects"

DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}/lib
	rm -v *.jar
	java-pkg_jar-from qdox-1.6
	java-pkg_jar-from junit
	java-pkg_jar-from ant-core
	java-pkg_jar-from mockobjects
}

src_compile() {
	eant compile # no javadoc support in build.xml
}

src_install() {
	java-pkg_dojar dist/tmp/${PN}.jar

	dohtml -r docs/website/*
	use source && java-pkg_dosrc src/*
}
