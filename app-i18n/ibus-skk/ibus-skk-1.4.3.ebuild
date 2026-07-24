# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools vala

DESCRIPTION="Japanese SKK engine for IBus"
HOMEPAGE="https://github.com/ueno/ibus-skk"
SRC_URI="https://github.com/ueno/${PN}/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

DEPEND="app-i18n/ibus
	>=app-i18n/libskk-1.0.2
	x11-libs/gtk+:3
	nls? ( virtual/libintl )"
RDEPEND="${DEPEND}
	app-i18n/skk-jisyo"
BDEPEND="$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-libskk-1.1.1.patch )

src_prepare() {
	vala_setup
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}
