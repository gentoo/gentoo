# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A file browser for rofi"
HOMEPAGE="https://github.com/marvinkreis/rofi-file-browser-extended"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/marvinkreis/${PN}.git"
else
	SRC_URI="https://github.com/marvinkreis/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="virtual/pkgconfig"
COMMON_DEPEND="
	dev-libs/glib:2
	x11-misc/rofi
"
DEPEND="
	${COMMON_DEPEND}
	x11-libs/cairo
"
RDEPEND="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-do-not-install-man-page.patch"
)

src_install() {
	cmake_src_install
	doman "doc/${PN}.1"
}
