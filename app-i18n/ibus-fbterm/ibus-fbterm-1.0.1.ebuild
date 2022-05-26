# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="IBus client for FbTerm"
HOMEPAGE="https://github.com/fujiwarat/ibus-fbterm"
SRC_URI="https://github.com/fujiwarat/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-i18n/ibus
	app-i18n/fbterm
	dev-libs/glib:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-clang.patch
	"${FILESDIR}"/${PN}-man.patch
)

AT_M4DIR="m4"

src_prepare() {
	default
	eautoreconf
}
