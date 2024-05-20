# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit desktop java-pkg-2 java-pkg-simple

DESCRIPTION="A java based flashcard program"
HOMEPAGE="https://pauker.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/pauker/pauker/${PV}/${P}.src.jar"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
CP_DEPEND="
	dev-java/browserlauncher2:1.0
	dev-java/javahelp:0
	dev-java/lucene:2.4
	dev-java/swing-layout:1
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/pauker-1.8-javadoc.patch" )

JAVA_MAIN_CLASS="pauker.program.gui.swing.PaukerFrame"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean
	cp -r src res || die
	find res -type f \( -name '*.java' -o -name '*.txt' \
		-o -name '*.form' -o -name '*BeanInfo.java' \
		-o -name '*Panel.gif' \) -exec rm -rf {} + || die
}

#test depend on jemmy, a netbeans module.  so unless it is packaged separately
#tests cannot be build.

src_install() {
	java-pkg-simple_src_install
	newicon src/pauker/icons/repeat.png ${PN}.png
	make_desktop_entry pauker Pauker
}
