# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.0
PVCUT=$(ver_cut 1-3)
inherit cmake plasma.kde.org

DESCRIPTION="Breeze theme for Plymouth"

LICENSE="GPL-2+ GPL-3+"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

BDEPEND=">=kde-frameworks/extra-cmake-modules-${KFMIN}:0"
DEPEND="sys-boot/plymouth"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DDISTRO_NAME="Gentoo Linux"
		-DDISTRO_VERSION=
	)

	cmake_src_configure
}
