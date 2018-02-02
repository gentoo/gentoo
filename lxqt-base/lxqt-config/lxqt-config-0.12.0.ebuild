# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils versionator

DESCRIPTION="LXQt system configuration control center"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="
	dev-libs/libqtxdg:0/3
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	kde-frameworks/kwindowsystem:5
	kde-plasma/libkscreen:5
	=lxqt-base/liblxqt-$(get_version_component_range 1-2)*
	sys-libs/zlib:=
	x11-apps/setxkbmap
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
"
DEPEND="${RDEPEND}
	>=dev-util/lxqt-build-tools-0.4.0
	dev-qt/linguist-tools:5
"

mycmakeargs=( -DPULL_TRANSLATIONS=OFF )

src_install(){
	cmake-utils_src_install
	doman man/*.1 liblxqt-config-cursor/man/*.1 lxqt-config-appearance/man/*.1
}
