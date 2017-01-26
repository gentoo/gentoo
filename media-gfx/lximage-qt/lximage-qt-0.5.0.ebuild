# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils

DESCRIPTION="LXImage Image Viewer - GPicView replacement"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://downloads.lxqt.org/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/libexif
	>=x11-libs/libfm-1.2:=
	x11-libs/libfm-qt:=
	x11-libs/libX11
	x11-libs/libXfixes"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	lxqt-base/liblxqt
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=OFF
	)
	cmake-utils_src_configure
}
