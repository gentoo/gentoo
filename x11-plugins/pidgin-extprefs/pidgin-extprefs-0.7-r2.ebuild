# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Extra preferences that are desired but are not worthy for Pidgin"
HOMEPAGE="http://gaim-extprefs.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/gaim-extprefs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv ~sparc x86"

RDEPEND="net-im/pidgin[gui]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
