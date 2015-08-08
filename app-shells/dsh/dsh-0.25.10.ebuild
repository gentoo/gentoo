# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

DESCRIPTION="Distributed Shell"
HOMEPAGE="http://www.netfort.gr.jp/~dancer/software/dsh.html.en"
SRC_URI="http://www.netfort.gr.jp/~dancer/software/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~m68k-mint"
IUSE="nls"

DEPEND="dev-libs/libdshconfig"
RDEPEND="${DEPEND}
	virtual/ssh"

src_configure() {
	econf --sysconfdir="${EPREFIX}"/etc/dsh $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodir /etc/dsh/group
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
