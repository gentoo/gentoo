# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake kde.org

DESCRIPTION="Plasma Specific Protocols for Wayland"
HOMEPAGE="https://invent.kde.org/libraries/plasma-wayland-protocols"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND="
	dev-libs/libpcre2:*
	>=kde-frameworks/extra-cmake-modules-5.115.0:*
	|| (
		dev-qt/qtbase:6
		dev-qt/qtcore:5
	)
"

ecm_src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_USE_QT_SYS_PATHS=ON # ecm.eclass
		-DKDE_INSTALL_DOCBUNDLEDIR="${EPREFIX}/usr/share/help" # ecm.eclass
	)

	cmake_src_configure
}
