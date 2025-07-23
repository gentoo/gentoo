# Copyright 1999-2025 Gentoo Authors
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
KEYWORDS="~amd64"
IUSE="ant-task"

DEPEND="
	>=virtual/jdk-1.8:*
	ant-task? ( >=dev-java/ant-1.10.14-r3:0 )
"

RDEPEND="
	>=virtual/jre-1.8:*
	media-gfx/graphviz
	ant-task? ( >=dev-java/ant-1.10.14-r3:0 )
"

JAVA_AUTOMATIC_MODULE_NAME="net.sourceforge.plantuml"
JAVA_MAIN_CLASS="net.sourceforge.plantuml.Run"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare

	# using media-gfx/graphviz
	rm -r src/main/java/net/sourceforge/plantuml/windowsdot/graphviz.dat || die

	if use ant-task; then
		# src/main/java/net/sourceforge/plantuml/ant/readme.md
		JAVA_GENTOO_CLASSPATH+="ant"
	else
		rm src/main/java/net/sourceforge/plantuml/ant/{CheckZip,PlantUml}Task.java || die
	fi

	# java-pkg-simple wants resources in a separate directory
	# excluding some files which are not included in upstream's jar
	cd src/main/java || die "cd src/main/java"
	find -type f \
		! -name '.editorconfig' \
		! -name '*.html' \
		! -name '*.java' \
		! -name '*.ttf' \
		! -name 'readme.md' \
		! -name 'README.md' |
		xargs cp --parent -t ../resources || die "separate resource files"
}

src_install() {
	java-pkg-simple_src_install
	make_desktop_entry plantuml
}
