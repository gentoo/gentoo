# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="PlantUML is used to draw UML diagram, using a simple and human readable text description"
HOMEPAGE="http://plantuml.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=virtual/jdk-1.6
"
RDEPEND="
	>=virtual/jre-1.6
	>=media-gfx/graphviz-2.26.3
"

EANT_BUILD_TARGET="dist"
EANT_GENTOO_CLASSPATH="ant-core"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar
	use source && java-pkg_dosrc src/*
}
