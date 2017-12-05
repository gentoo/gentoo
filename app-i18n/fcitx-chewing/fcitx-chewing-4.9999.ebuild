# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils gnome2-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-chewing"
fi

DESCRIPTION="Chinese Chewing input method for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-chewing"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS=""
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.9:4
	>=app-i18n/libchewing-0.5.0:=
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS)

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
