# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

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
	sed -i '/-fsanitize=/d' test/CMakeLists.txt || die

	# Fix build with clang and lld.
	# https://bugs.gentoo.org/831338
	append-flags -fPIC
}
