# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils xdg

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/kcm-fcitx"
	EGIT_BRANCH="kde4"
fi

DESCRIPTION="KDE configuration module for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/kcm-fcitx"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="minimal"

RDEPEND=">=app-i18n/fcitx-4.2.8[dbus,qt4]
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	kde-base/kdelibs:4
	virtual/libintl
	x11-libs/libX11
	x11-libs/libxkbfile"
DEPEND="${RDEPEND}
	dev-util/automoc
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	if use minimal; then
		cmake_comment_add_subdirectory po
	fi

	cmake-utils_src_prepare
}
