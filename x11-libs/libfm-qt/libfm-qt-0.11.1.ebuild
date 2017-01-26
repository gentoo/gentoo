# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Qt port of libfm, a library providing components to build desktop file managers"
HOMEPAGE="http://lxqt.org/"

LICENSE="LGPL-2.1+"
SLOT="0/3"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=lxde-base/menu-cache-0.4.1
	>=x11-libs/libfm-1.2.0:=
	x11-libs/libxcb:=
	!<x11-misc/pcmanfm-qt-0.11.0
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	lxqt-base/liblxqt
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=NO
	)

	cmake-utils_src_configure
}
