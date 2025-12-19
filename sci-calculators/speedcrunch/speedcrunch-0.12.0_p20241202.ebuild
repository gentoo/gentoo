# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=3c1b4c18ccb275eb2891f9d8ff36a9205c0f566b
inherit cmake desktop xdg

DESCRIPTION="Fast and usable calculator for power users"
HOMEPAGE="https://heldercorreia.bitbucket.io/speedcrunch/"
SRC_URI="https://bitbucket.org/heldercorreia/speedcrunch/get/${COMMIT}.tar.bz2 -> ${P}-${COMMIT:0:12}.tar.bz2"
S="${WORKDIR}/heldercorreia-${PN}-${COMMIT:0:12}"
CMAKE_USE_DIR="${S}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qttools:6[assistant]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-qhash.patch"
	"${FILESDIR}/${P}-qsignalmapper.patch"
)

src_install() {
	local HTML_DOCS=( "${S}"/doc/build_html_embedded/. )
	cmake_src_install
	doicon -s scalable gfx/speedcrunch.svg
}
