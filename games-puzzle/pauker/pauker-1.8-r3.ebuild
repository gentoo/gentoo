# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit desktop java-pkg-2 java-ant-2

DESCRIPTION="A java based flashcard program"
HOMEPAGE="https://pauker.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/pauker/pauker/${PV}/${P}.src.jar"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/browserlauncher2:1.0
	dev-java/javahelp
	dev-java/lucene:2.4
	dev-java/swing-layout:1
"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.8:*"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.8:*"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${PN}_bundledjars.patch"
	"${FILESDIR}/pauker-1.8-r3-project.properties.patch"
)

src_prepare() {
	default
	find . -iname '*.jar' -delete || die

	java-pkg_jar-from --into libs browserlauncher2-1.0 browserlauncher2.jar BrowserLauncher2-1_3.jar
	java-pkg_jar-from --into libs javahelp jhall.jar
	java-pkg_jar-from --into libs lucene-2.4 lucene-core.jar lucene-core-2.4.0.jar
	java-pkg_jar-from --into libs swing-layout-1 swing-layout.jar
}

src_compile() {
	eant -Dfile.reference.BrowserLauncher2-1_3.jar="libs/BrowserLauncher2-1_3.jar" \
		-Dlibs.swing-layout.classpath="libs/swing-layout.jar" \
		-Dplatforms.JDK_1.8.home="${JAVA_HOME}" jar $(use_doc javadoc)
}

#test depend on jemmy, a netbeans module.  so unless it is packaged separately
#tests cannot be build.

src_install() {
	java-pkg_jarinto "/usr/share/${PN}"
	java-pkg_newjar "dist/${P}.jar"

	java-pkg_dolauncher ${PN} \
		-into "/usr" \
		--pwd /usr/share/${PN} \
		--main pauker.program.gui.swing.PaukerFrame

	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src

	newicon src/pauker/icons/repeat.png ${PN}.png
	make_desktop_entry pauker Pauker
}
