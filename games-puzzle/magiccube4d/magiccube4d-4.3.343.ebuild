# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 java-pkg-simple xdg

DESCRIPTION="Four-dimensional analog of Rubik's cube"
HOMEPAGE="https://www.superliminal.com/cube/cube.htm"
SRC_URI="https://github.com/cutelyaware/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

PATCHES=(
	"${FILESDIR}"/${PN}-xdg-config.patch
)

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS=( src )

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main com.superliminal.magiccube4d.MC4DSwing --java_args "-Xms128m -Xmx512m"

	newicon -s 32 src/mc4d.png ${PN}.png
	make_desktop_entry ${PN} "Magic Cube 4D"

	dodoc README.md
}
