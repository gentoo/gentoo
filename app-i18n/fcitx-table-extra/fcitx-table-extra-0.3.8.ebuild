# Copyright 2012-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake xdg-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-table-extra"
fi

DESCRIPTION="Extra Chinese table input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-table-extra"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"
IUSE=""

BDEPEND=">=app-i18n/fcitx-4.2.9:4
	virtual/pkgconfig"
DEPEND=">=app-i18n/fcitx-4.2.9:4[table]"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS)

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
