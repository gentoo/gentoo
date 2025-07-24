# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.10.0
inherit cmake plasma.kde.org

DESCRIPTION="Breeze theme for Plymouth"

LICENSE="GPL-2+ GPL-3+"
SLOT="6"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~x86"
IUSE=""

BDEPEND=">=kde-frameworks/extra-cmake-modules-${KFMIN}:0"
DEPEND="sys-boot/plymouth"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-6.2.5-cmake4.patch" )

src_configure() {
	local mycmakeargs=(
		-DDISTRO_NAME="Gentoo Linux"
		-DDISTRO_VERSION=
	)

	cmake_src_configure
}
