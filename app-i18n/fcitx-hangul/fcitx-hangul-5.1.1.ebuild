# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-hangul"

inherit cmake xdg

DESCRIPTION="Korean Hangul input method for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-hangul"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

DEPEND="
	>=app-i18n/fcitx-5.1.6:5
	>=app-i18n/libhangul-0.0.12
	virtual/libiconv
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"
DOCS=( AUTHORS )
