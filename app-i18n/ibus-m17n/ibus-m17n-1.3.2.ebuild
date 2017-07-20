# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="The M17N engine IMEngine for IBus Framework"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ibus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk nls"

CDEPEND="app-i18n/ibus
	dev-libs/m17n-lib
	gtk? ( x11-libs/gtk+:2 )
	nls? ( virtual/libintl )"
RDEPEND="${CDEPEND}
	dev-db/m17n-db
	dev-db/m17n-contrib"
DEPEND="${CDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with gtk gtk 2.0)
}
