# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Tools for accessing and converting various ebook file formats"
HOMEPAGE="https://sourceforge.net/projects/ebook-tools/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="+lit2epub"

DEPEND="
	dev-libs/libxml2
	dev-libs/libzip:=
"
RDEPEND="${DEPEND}
	lit2epub? ( app-text/convertlit	)
"

src_prepare() {
	cmake-utils_src_prepare

	use lit2epub || sed -i -e '\|lit2epub|d' -- 'src/tools/CMakeLists.txt' || die
}
