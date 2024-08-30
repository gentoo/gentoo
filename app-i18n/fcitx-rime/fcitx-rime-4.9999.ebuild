# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake xdg-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-rime"
fi

DESCRIPTION="Chinese RIME input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-rime"
if [[ ! "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="4"
IUSE="+configuration-tool"

BDEPEND=">=app-i18n/fcitx-4.2.9:4
	virtual/pkgconfig
	configuration-tool? (
		dev-qt/qtcore:5
		dev-qt/qtwidgets:5
	)"
DEPEND=">=app-i18n/fcitx-4.2.9:4
	<app-i18n/librime-1.9.0:=
	virtual/libintl
	configuration-tool? (
		>=app-i18n/fcitx-qt5-1.1:4
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
RDEPEND="${DEPEND}
	app-i18n/rime-data"
DEPEND="${DEPEND}
	configuration-tool? ( dev-qt/qtconcurrent:5 )"

DOCS=()

src_configure() {
	local mycmakeargs=(
		-DRIME_DATA_DIR="${EPREFIX}/usr/share/rime-data"
		-DENABLE_QT5GUI=$(usex configuration-tool)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
