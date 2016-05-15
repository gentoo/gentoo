# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Library for parsing/handling of command line parameters"
HOMEPAGE="http://jcmdline.sourceforge.net/"
SRC_URI="mirror://sourceforge/jcmdline/${P}.zip"
LICENSE="MPL-1.1"
SLOT="1.0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

EANT_DOC_TARGET="doc"

java_prepare() {
	find -name "*.jar" -delete || die
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_install() {
	java-pkg_dojar ${PN}.jar

	dodoc CHANGES CREDITS README
	use doc && java-pkg_dojavadoc doc/jcmdline/api
	use source && java-pkg_dosrc src/*
}
