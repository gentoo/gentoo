# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils gnome2-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/fcitx/fcitx-rime.git"
fi

DESCRIPTION="Chinese RIME input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://gitlab.com/fcitx/fcitx-rime"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="4"
KEYWORDS=""
IUSE="+configuration_tool"

RDEPEND=">=app-i18n/fcitx-4.2.9:4
	>=app-i18n/librime-1.0.0:=
	app-i18n/rime-data
	virtual/libintl
	configuration_tool? (
		>=app-i18n/fcitx-qt5-1.1:4
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	configuration_tool? ( dev-qt/qtconcurrent:5 )"

DOCS=()

src_configure() {
	local mycmakeargs=(
		-DRIME_DATA_DIR="${EPREFIX}/usr/share/rime-data"
		-DENABLE_QT5GUI=$(usex configuration_tool)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
