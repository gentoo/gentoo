# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="LXQT session manager"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

IUSE="+themes"
LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="
	>=dev-libs/libqtxdg-1.0.0:=
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5=
	dev-qt/qtxml:5=
	kde-frameworks/kwindowsystem:5=[X]
	~lxqt-base/liblxqt-${PV}
	x11-libs/libX11
	x11-misc/xdg-user-dirs
	themes? ( ~x11-themes/lxqt-themes-${PV} )
	!!lxqt-base/lxqt-common
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5=
	>=dev-util/lxqt-build-tools-0.4.0
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman lxqt-config-session/man/*.1 lxqt-session/man/*.1
}
