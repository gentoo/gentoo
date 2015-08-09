# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Jar Bundler Ant Task"
HOMEPAGE="http://www.loomcom.com/jarbundler/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4
		 dev-java/ant-core"

src_compile() {
	eant jar -Dant.jar="$(java-pkg_getjar ant-core ant.jar)" $(use_doc javadocs)
}

src_install() {
	java-pkg_newjar "build/${P}.jar"
	use doc && java-pkg_dojavadoc javadoc/
	use source && java-pkg_dosrc src/*
}
