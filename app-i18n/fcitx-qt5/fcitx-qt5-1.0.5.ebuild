# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-qt5"
fi

DESCRIPTION="Fcitx input method module for Qt 5"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-qt5"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

# Private headers of dev-qt/qtgui:5 used.
RDEPEND=">=app-i18n/fcitx-4.2.8
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5
	virtual/libintl
	x11-libs/libxkbcommon"
DEPEND="${RDEPEND}
	kde-frameworks/extra-cmake-modules:5
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-ucs4.patch"
)

DOCS=()
