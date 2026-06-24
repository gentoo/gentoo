# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# minimum taken from Kvantum/style/CMakeLists.txt
# increased downstream to ensure sane upgrades
QTMIN="6.8.2"
KFMIN="6.13.0"
inherit cmake verify-sig xdg

DESCRIPTION="SVG-based theme engine for Qt, KDE Plasma and LXQt"
HOMEPAGE="https://github.com/tsujan/Kvantum"
SRC_URI="
	https://github.com/tsujan/${PN^}/releases/download/V${PV}/${P^}.tar.xz
	verify-sig? ( https://github.com/tsujan/${PN^}/releases/download/V${PV}/${P^}.tar.xz.asc )
"
S="${WORKDIR}/${PN^}-${PV}/${PN^}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="kde"

RESTRICT="test" # no tests

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,X]
	>=dev-qt/qtsvg-${QTMIN}:6
	x11-libs/libX11
	kde? ( >=kde-frameworks/kwindowsystem-${KFMIN}:6 )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	verify-sig? ( sec-keys/openpgp-keys-tsujan )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/tsujan.asc"

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT4=OFF
		-DENABLE_QT5=OFF
		-DWITHOUT_KF=$(usex !kde)
	)
	cmake_src_configure
}
