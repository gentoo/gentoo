# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt GUI Openbox Configuration Tool"
HOMEPAGE="https://lxqt.github.io/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2 GPL-2+"
SLOT="0"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.0.0
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	>=dev-qt/qtbase-6.6:6[gui,widgets]
	x11-libs/libX11
	x11-wm/openbox:3
"
DEPEND="${RDEPEND}"
