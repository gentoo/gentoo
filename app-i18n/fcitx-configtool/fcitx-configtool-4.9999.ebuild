# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-configtool"
fi

DESCRIPTION="GTK+ GUI configuration tool for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-configtool"
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
	app-text/iso-codes
	dev-libs/glib:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=()

src_configure() {
	local mycmakeargs=(
		-DENABLE_GTK2=OFF
		-DENABLE_GTK3=ON
	)

	cmake-utils_src_configure
}
