# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt daemon for power management and auto-suspend"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64   ~x86"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

CDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	~lxqt-base/liblxqt-${PV}
	>=dev-libs/libqtxdg-1.0.0
	x11-libs/libX11
	x11-libs/libxcb:="
DEPEND="${CDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	|| ( sys-power/upower sys-power/upower-pm-utils )"
