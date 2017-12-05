# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-m17n"
fi

DESCRIPTION="m17n-provided input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-m17n"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="LGPL-2.1+"
SLOT="4"
KEYWORDS=""
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.9:4
	dev-libs/m17n-lib
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=()
