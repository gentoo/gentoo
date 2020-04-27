# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="LXQt quick launcher"
HOMEPAGE="https://lxqt.github.io/"

MY_PV="$(ver_cut 1-2)*"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

LICENSE="LGPL-2.1 LGPL-2.1+"
SLOT="0"

BDEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.7.0
	virtual/pkgconfig
"
DEPEND="
	>=dev-cpp/muParser-2.2.3:=
	>=dev-libs/libqtxdg-3.3.1
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kwindowsystem:5
	=lxqt-base/liblxqt-${MY_PV}
	=lxqt-base/lxqt-globalkeys-${MY_PV}
"
RDEPEND="${DEPEND}
	!lxqt-base/lxqt-l10n
"

src_install() {
	cmake_src_install
	doman man/*.1
}
