# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake unpacker xdg

MY_PN="fcitx5-rime"
DESCRIPTION="Chinese RIME input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-rime"
SRC_URI="https://download.fcitx-im.org/fcitx5/fcitx5-rime/fcitx5-rime-${PV}.tar.zst -> ${P}.tar.zst"

S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~loong ~riscv x86"

DEPEND="
	!app-i18n/fcitx-rime:4
	>=app-i18n/fcitx-5.1.13:5
	app-i18n/librime
	app-i18n/rime-data
	virtual/libintl
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	sys-devel/gettext
	virtual/pkgconfig
"
