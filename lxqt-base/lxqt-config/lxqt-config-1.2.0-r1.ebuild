# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake xdg-utils

DESCRIPTION="LXQt system configuration control center"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 GPL-2+ GPL-3 LGPL-2 LGPL-2+ LGPL-2.1+ WTFPL-2"
SLOT="0"
IUSE="+monitor +touchpad"

BDEPEND="
	>=dev-qt/linguist-tools-5.15:5
"
DEPEND="
	>=dev-libs/libqtxdg-3.10.0
	>=dev-qt/qtcore-5.15:5
	>=dev-qt/qtgui-5.15:5
	>=dev-qt/qtwidgets-5.15:5
	>=dev-qt/qtsvg-5.15:5
	>=dev-qt/qtx11extras-5.15:5
	>=dev-qt/qtxml-5.15:5
	=lxqt-base/liblxqt-${MY_PV}*:=
	sys-libs/zlib:=
	x11-apps/setxkbmap
	x11-libs/libxcb:=
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXfixes
	monitor? ( kde-plasma/libkscreen:5= )
	touchpad? (
		virtual/libudev:=
		x11-drivers/xf86-input-libinput
		x11-libs/libXi
	)
"
RDEPEND="${DEPEND}"

# https://bugs.gentoo.org/894468
# https://github.com/lxqt/lxqt-config/pull/915
PATCHES=( "${FILESDIR}"/"${PN}"-kscreen-52690.patch )

src_configure() {
	local mycmakeargs=(
		-DWITH_MONITOR=$(usex monitor)
		-DWITH_TOUCHPAD=$(usex touchpad)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman man/*.1 liblxqt-config-cursor/man/*.1 lxqt-config-appearance/man/*.1
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
