# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils versionator

DESCRIPTION="Qt port of libfm, a library providing components to build desktop file managers"
HOMEPAGE="http://lxqt.org/"

MY_PV="$(get_version_component_range 1-2)*"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0/3"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=lxde-base/menu-cache-1.1.0
	=lxqt-base/liblxqt-${MY_PV}
	media-libs/libexif:=
	>=x11-libs/libfm-1.2.0:=
	x11-libs/libxcb:=
	=x11-misc/pcmanfm-qt-${MY_PV}
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.4.0
	virtual/pkgconfig
"

mycmakeargs=( -DPULL_TRANSLATIONS=NO )
