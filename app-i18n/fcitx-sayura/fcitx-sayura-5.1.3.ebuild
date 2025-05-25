# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg unpacker

MY_PN="fcitx5-sayura"
DESCRIPTION="Fcitx-Sayura is a Sinhala input method for Fcitx input method framework"
HOMEPAGE="https://github.com/fcitx/fcitx5-sayura"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.zst -> ${P}.tar.zst"

S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="LGPL-2.1+ MIT"
SLOT="5"
KEYWORDS="~amd64"

DEPEND="
	>=app-i18n/fcitx-5.1.12:5
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
"

PATCHES=(
	"${FILESDIR}/${PN}-fix-cmake-4.patch"
)
