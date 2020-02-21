# Copyright 2012-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/fcitx/fcitx-cloudpinyin.git"
fi

DESCRIPTION="Internet look-up support for Chinese Pinyin input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://gitlab.com/fcitx/fcitx-cloudpinyin"
if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND=">=app-i18n/fcitx-4.2.9:4
	net-misc/curl:=
	virtual/libiconv
	virtual/libintl"
RDEPEND="${DEPEND}"

DOCS=()
