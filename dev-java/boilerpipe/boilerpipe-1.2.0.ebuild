# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Boilerplate Removal and Fulltext Extraction from HTML pages"
HOMEPAGE="https://github.com/kohlschutter/boilerpipe"
SRC_URI="https://${PN}.googlecode.com/files/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

CDEPEND="dev-java/xerces:2
	dev-java/nekohtml:0"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

EANT_BUILD_TARGET="jars"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="xerces-2,nekohtml"

java_prepare() {
	mkdir "${S}"/lib || die
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	use source && java-pkg_dosrc src/main/*
}
