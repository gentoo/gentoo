# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="pidgin plugin to stop spammers from annoying you"
HOMEPAGE="https://code.google.com/p/pidgin-privacy-please/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="<net-im/pidgin-3[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	default
	sed -e 's: -Wall -g3::' -i configure.ac || die
	eautoreconf
}
