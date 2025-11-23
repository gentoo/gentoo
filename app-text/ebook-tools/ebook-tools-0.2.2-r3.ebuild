# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tools for accessing and converting various ebook file formats"
HOMEPAGE="https://sourceforge.net/projects/ebook-tools/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv x86"
IUSE="+lit2epub"

DEPEND="
	dev-libs/libxml2:=
	>=dev-libs/libzip-1.7.2:=
"
RDEPEND="${DEPEND}
	lit2epub? ( app-text/convertlit )
"

PATCHES=(
	"${FILESDIR}/${P}-crashfix.patch"
	"${FILESDIR}/${P}-fvisibility-hidden.patch"
	"${FILESDIR}/${P}-libzip-cmake.patch"
	"${FILESDIR}/${P}-cmake4.patch" # bug 955639
)

src_prepare() {
	cmake_src_prepare
	use lit2epub || sed -e "\|lit2epub|d" -i src/tools/CMakeLists.txt || die
}
