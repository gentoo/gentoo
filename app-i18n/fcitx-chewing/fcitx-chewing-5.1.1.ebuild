# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-chewing"

inherit cmake xdg

DESCRIPTION="Chewing Wrapper for Fcitx."
HOMEPAGE="https://github.com/fcitx/fcitx5-chewing"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	>=app-i18n/fcitx-5.1.6:5
	>=app-i18n/libchewing-0.5.0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"
