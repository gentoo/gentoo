# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Extension Library for Tox"
HOMEPAGE="https://github.com/toxext/toxext"
SRC_URI="https://github.com/toxext/toxext/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="net-libs/tox:="
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare

	sed -i 's/-Werror//' CMakeLists.txt || die
}
