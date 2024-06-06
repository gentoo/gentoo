# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-pkg-simple desktop xdg

DESCRIPTION="Draw UML diagrams using a simple and human readable text description"
HOMEPAGE="https://plantuml.com"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND=">=virtual/jdk-1.8:*
	>=dev-java/ant-1.10.14-r1:0"
RDEPEND=">=virtual/jre-1.8:*
	media-gfx/graphviz"

JAVA_AUTOMATIC_MODULE_NAME="net.sourceforge.plantuml"
JAVA_CLASSPATH_EXTRA="ant"
JAVA_MAIN_CLASS="net.sourceforge.plantuml.Run"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare

	# java-pkg-simple wants resources in a separate directory
	cp -r src res || die
	cp -r skin stdlib svg themes res || die
	find res -type f \( -name '*.java' -o -iname 'readme.md' \
		-o -name '*.ttf' -o -name '*.html' -o -name 'data.txt' \
		-o -name '.editorconfig' \) -exec rm -rf {} + || die
}

src_install() {
	java-pkg-simple_src_install
	make_desktop_entry plantuml
}
