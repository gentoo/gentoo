# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-anthy"

inherit cmake unpacker xdg

DESCRIPTION="Japanese Anthy input methods for Fcitx5"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-anthy"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.zst"

S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~loong ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!app-i18n/fcitx-anthy:4
	app-i18n/anthy
	>=app-i18n/fcitx-5.1.12:5
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

DOCS=( AUTHORS )
