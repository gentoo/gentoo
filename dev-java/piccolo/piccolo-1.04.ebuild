# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A small, extremely fast XML parser for Java"
HOMEPAGE="http://piccolo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

EANT_BUILD_TARGET="build"

src_install() {
	java-pkg_dojar lib/Piccolo.jar

	dodoc README.txt
	use doc && java-pkg_dojavadoc doc/javadoc

	use source && java-pkg_dosrc src/*
}
