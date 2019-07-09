# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Reversi game for GNOME, supporting the Go/Game Text Protocol"
HOMEPAGE="http://rhino.sourceforge.net/"
SRC_URI="mirror://sourceforge/rhino/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	sed -i '/^(\|locale\|help\|omf\|icon\|)/s:@datadir@:/usr/share:' \
		Makefile.in || die
}

src_configure() {
	econf \
		--localedir=/usr/share/locale \
		--enable-gtp \
		--disable-gnome \
		$(use_enable nls)
}
