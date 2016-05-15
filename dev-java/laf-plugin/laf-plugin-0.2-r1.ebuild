# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A generic plugin framework for look-and-feels"
HOMEPAGE="http://laf-plugin.dev.java.net/"
SRC_URI="mirror://gentoo/${P}-src.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

EANT_BUILD_TARGET="dist"

java_prepare() {
	cp "${FILESDIR}/${P}-build.xml" build.xml || die
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"

	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc src/org
}
