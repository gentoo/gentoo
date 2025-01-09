# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake kde.org

DESCRIPTION="Plasma Specific Protocols for Wayland"
HOMEPAGE="https://invent.kde.org/libraries/plasma-wayland-protocols"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/wayland )"
BDEPEND="
	dev-libs/libpcre2:*
	dev-qt/qtbase:6
	>=kde-frameworks/extra-cmake-modules-6.0:*
	test? ( dev-util/wayland-scanner )
"

src_configure() {
	local mycmakeargs=(
		-DQT_MAJOR_VERSION=6
		-DKDE_INSTALL_USE_QT_SYS_PATHS=ON # ecm.eclass
		-DKDE_INSTALL_DOCBUNDLEDIR="${EPREFIX}/usr/share/help" # ecm.eclass
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
