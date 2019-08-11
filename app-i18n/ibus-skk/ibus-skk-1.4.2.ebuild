# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit vala

DESCRIPTION="Japanese SKK engine for IBus"
HOMEPAGE="https://github.com/ueno/ibus-skk"
SRC_URI="https://github.com/ueno/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

CDEPEND="app-i18n/ibus
	>=app-i18n/libskk-1.0.2
	x11-libs/gtk+:3
	nls? ( virtual/libintl )"
RDEPEND="${CDEPEND}
	app-i18n/skk-jisyo"
DEPEND="${CDEPEND}
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	vala_src_prepare
	default
}

src_configure() {
	econf $(use_enable nls)
}
