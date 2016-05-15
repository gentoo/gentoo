# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JIDE Common Layer (Professional Swing Components)"
HOMEPAGE="https://github.com/jidesoft/jide-oss"
SRC_URI="https://github.com/jidesoft/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

java_prepare() {
	rm -rv libs/ src/com/jidesoft/plaf/aqua/ || die
}

src_install() {
	java-pkg_newjar ${P}.jar ${PN}.jar
	dodoc README.txt

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/*
}
