# Copyright 2012-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake xdg-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-rime"
fi

DESCRIPTION="Chinese RIME input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-rime"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"
IUSE=""

BDEPEND=">=app-i18n/fcitx-4.2.9:4
	virtual/pkgconfig"
DEPEND=">=app-i18n/fcitx-4.2.9:4
	>=app-i18n/librime-1.0.0:=
	virtual/libintl"
RDEPEND="${DEPEND}
	app-i18n/rime-data"

DOCS=()

src_configure() {
	local mycmakeargs=(
		-DRIME_DATA_DIR="${EPREFIX}/usr/share/rime-data"
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
