# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="LXQT session manager"
HOMEPAGE="https://lxqt.org/"

MY_PV="$(ver_cut 1-2)*"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
fi

IUSE="+themes +udev"

LICENSE="LGPL-2.1+"
SLOT="0"

BDEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.6.0
"
DEPEND="
	>=dev-libs/libqtxdg-3.3.1
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	kde-frameworks/kwindowsystem:5[X]
	=lxqt-base/liblxqt-${MY_PV}
	x11-libs/libX11
	x11-misc/xdg-user-dirs
	themes? ( =x11-themes/lxqt-themes-${MY_PV} )
	udev? ( virtual/libudev )
"
RDEPEND="${DEPEND}
	!lxqt-base/lxqt-l10n
"

src_configure() {
	local mycmakeargs=(
		-DWITH_LIBUDEV=$(usex udev)
	)
	cmake_src_configure
}

src_install(){
	cmake_src_install
	doman lxqt-config-session/man/*.1 lxqt-session/man/*.1

	echo XDG_CONFIG_DIRS=\"${EPREFIX}/usr/share\" >> 91lxqt-config-dir
	doenvd 91lxqt-config-dir
}
