# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="LXQt daemon for power management and auto-suspend"
HOMEPAGE="https://lxqt.github.io/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

BDEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.6.0
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/libqtxdg-3.3.1
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	kde-frameworks/kidletime:5
	kde-frameworks/solid:5
	=lxqt-base/liblxqt-$(ver_cut 1-2)*
	sys-power/upower
"
RDEPEND="${DEPEND}
	!lxqt-base/lxqt-l10n
"
