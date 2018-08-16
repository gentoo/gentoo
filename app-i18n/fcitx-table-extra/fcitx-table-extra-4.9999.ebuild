# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils gnome2-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/fcitx/fcitx-table-extra.git"
fi

DESCRIPTION="Extra Chinese table input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://gitlab.com/fcitx/fcitx-table-extra"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS=""
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.9:4[table]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS)

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
