# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A vector based graphics editor similar to xfig, but simpler"
HOMEPAGE="http://figurine.sourceforge.net/"
SRC_URI="mirror://sourceforge/figurine/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=media-gfx/transfig-3.2"

src_configure() {
	econf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README
}
