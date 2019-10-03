# Copyright 2013-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils xdg-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/fcitx/fcitx-hangul.git"
fi

DESCRIPTION="Korean Hangul input method for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://gitlab.com/fcitx/fcitx-hangul"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="BSD GPL-2+"
SLOT="4"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

BDEPEND="sys-devel/gettext
	virtual/pkgconfig"
DEPEND=">=app-i18n/fcitx-4.2.9:4
	app-i18n/libhangul:=
	virtual/libiconv
	virtual/libintl"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS)

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
