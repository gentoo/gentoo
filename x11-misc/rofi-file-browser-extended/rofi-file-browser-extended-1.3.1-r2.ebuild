# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A file browser for rofi"
HOMEPAGE="https://github.com/marvinkreis/rofi-file-browser-extended"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/marvinkreis/${PN}.git"
else
	SRC_URI="https://github.com/marvinkreis/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

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
	# https://bugs.gentoo.org/880985 https://github.com/marvinkreis/rofi-file-browser-extended/pull/49
	"${FILESDIR}/${PN}-1.3.1-fix-function-pointer-initialization.patch"
	"${FILESDIR}/${PN}-1.3.1-fix-gcc14-build-fix.patch"
)

src_prepare() {
	# Delete the lines in CMakeLists.txt that install the man page.
	sed -i "45,56d" CMakeLists.txt || die
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	doman "doc/${PN}.1"
}
