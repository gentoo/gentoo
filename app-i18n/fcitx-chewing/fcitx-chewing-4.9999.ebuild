# Copyright 2013-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils xdg-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/fcitx/fcitx-chewing.git"
fi

DESCRIPTION="Chinese Chewing input method for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://gitlab.com/fcitx/fcitx-chewing"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS=""
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND=">=app-i18n/fcitx-4.2.9:4
	>=app-i18n/libchewing-0.5.0:=
	virtual/libintl"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS)

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
