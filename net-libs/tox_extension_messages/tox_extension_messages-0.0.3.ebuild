# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tox Extension Messages"
HOMEPAGE="https://github.com/toxext/tox_extension_messages"
SRC_URI="https://github.com/toxext/tox_extension_messages/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="net-libs/toxext"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare

	sed -i 's/-Werror//' CMakeLists.txt || die
}
