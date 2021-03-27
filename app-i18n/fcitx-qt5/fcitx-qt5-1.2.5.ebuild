# Copyright 2014-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-qt5"
fi

DESCRIPTION="Fcitx input method module for Qt 5"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-qt5"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="BSD GPL-2+ GPL-3+ LGPL-2+"
SLOT="4"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE=""

BDEPEND=">=app-i18n/fcitx-4.2.9:4
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtwidgets:5
	kde-frameworks/extra-cmake-modules:5
	virtual/pkgconfig"
# Private headers of dev-qt/qtgui:5 used.
RDEPEND=">=app-i18n/fcitx-4.2.9:4
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5
	virtual/libintl
	x11-libs/libxkbcommon"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5"

PATCHES=(
	"${FILESDIR}/${P}-QFcitxPlatformInputContext_recursion.patch"
)

DOCS=()
