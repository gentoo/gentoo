# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Japanese SKK engine for IBus"
HOMEPAGE="https://github.com/ueno/ibus-skk"
SRC_URI="mirror://github/ueno/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

CDEPEND="app-i18n/ibus
	<=app-i18n/libskk-1.0.1
	x11-libs/gtk+:3
	nls? ( virtual/libintl )"
RDEPEND="${CDEPEND}
	app-i18n/skk-jisyo"
DEPEND="${CDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS="ChangeLog NEWS README THANKS"

src_configure() {
	econf $(use_enable nls)
}
