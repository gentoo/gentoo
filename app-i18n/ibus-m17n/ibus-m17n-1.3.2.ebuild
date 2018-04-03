# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="M17N engine for IBus"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ibus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk gtk2 nls"

CDEPEND="app-i18n/ibus
	dev-libs/m17n-lib
	gtk? (
		gtk2? ( x11-libs/gtk+:2 )
		!gtk2? ( x11-libs/gtk+:3 )
	)
	nls? ( virtual/libintl )"
RDEPEND="${CDEPEND}
	>=dev-db/m17n-db-1.7"
DEPEND="${CDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
REQUIRED_USE="gtk2? ( gtk )"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with gtk gtk $(usex gtk2 2.0 3.0))
}
