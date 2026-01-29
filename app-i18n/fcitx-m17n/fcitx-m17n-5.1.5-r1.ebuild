# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-m17n"

inherit cmake unpacker

DESCRIPTION="m17n-provided input methods for Fcitx5"
HOMEPAGE="https://github.com/fcitx/fcitx5-m17n"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.zst -> ${P}.tar.zst"

S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

# m17n-gui>=1.6.3
RDEPEND="
	>=app-i18n/fcitx-5.1.13:5
	dev-db/m17n-db
	>=dev-libs/m17n-lib-1.6.3[X]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	kde-frameworks/extra-cmake-modules:0
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_TEST=$(usex test)
	)
	cmake_src_configure
}
