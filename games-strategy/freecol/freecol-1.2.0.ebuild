# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit desktop java-pkg-2 java-pkg-simple

DESCRIPTION="An open source clone of the game Colonization"
HOMEPAGE="https://www.freecol.org/"
SRC_URI="https://downloads.sourceforge.net/project/freecol/freecol/${P}/${P}-src.zip"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/commons-cli:0
	dev-java/cortado:0
	dev-java/findbugs-annotations:0
	dev-java/miglayout:5
"

DEPEND=">=virtual/jdk-11:*
	${CP_DEPEND}"

# error: variables in try-with-resources are not supported in -source 8
RDEPEND=">=virtual/jre-11:*
	${CP_DEPEND}"

BDEPEND="app-arch/unzip"

DOCS=(
	CHANGELOG.md
	COPYING
	README
	README.md
	SECURITY.md
)

JAVA_JAR_FILENAME="FreeCol.jar"
JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="src"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RUN_ONLY="net.sf.freecol.AllTests"
JAVA_TEST_SRC_DIR="test/src"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
	mkdir -p "${JAVA_RESOURCE_DIRS}/META-INF" || die
	cp build/splash.jpg "${JAVA_RESOURCE_DIRS}" || die
	grep Main-Class src/MANIFEST.MF \
		> "${JAVA_RESOURCE_DIRS}/META-INF/MANIFEST.MF" || die
}

src_install() {
	java-pkg-simple_src_install

	local datadir=/usr/share/${PN}

	# launcher of java-pkg-simple.eclass seems not to support --pwd
	java-pkg_dolauncher ${PN} \
		--pwd ${datadir} \
		--main net.sf.freecol.FreeCol \
		--java_args -Xmx2000M

	insinto ${datadir}
	doins -r data schema

	doicon data/${PN}.png
	make_desktop_entry ${PN} FreeCol
}
