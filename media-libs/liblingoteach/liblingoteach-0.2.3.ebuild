# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="A library to support lingoteach-ui and for generic lesson development"
HOMEPAGE="http://lingoteach.sourceforge.net"
SRC_URI="mirror://sourceforge/lingoteach/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="debug zlib"

RDEPEND="zlib? ( sys-libs/zlib )
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --disable-dependency-tracking \
		$(use_enable zlib compression) \
		$(use_enable debug)
}

src_install() {
	emake HTML_DIR="/usr/share/doc/${PF}" DOC_MODULE="" \
		DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog HACKING NEWS README
}
