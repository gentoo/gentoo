# Copyright 2016-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

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
KEYWORDS="amd64 ~hppa ppc ppc64 ~riscv x86"
IUSE=""

BDEPEND=">=app-i18n/fcitx-4.2.9:4
	virtual/pkgconfig"
DEPEND=">=app-i18n/fcitx-4.2.9:4
	dev-libs/m17n-lib
	virtual/libintl"
RDEPEND="${DEPEND}"

DOCS=()
