# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="source"
inherit java-pkg-2 java-ant-2 desktop xdg

DESCRIPTION="Draw UML diagrams using a simple and human readable text description"
HOMEPAGE="https://plantuml.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"

RDEPEND="
	>=virtual/jre-1.8:*
	dev-java/ant-core:0
	media-gfx/graphviz"

EANT_BUILD_TARGET="dist"
EANT_GENTOO_CLASSPATH="ant-core"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar
	use source && java-pkg_dosrc src/*

	make_desktop_entry plantuml PlantUML
}
