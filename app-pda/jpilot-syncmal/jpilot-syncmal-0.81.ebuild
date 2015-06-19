# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/jpilot-syncmal/jpilot-syncmal-0.81.ebuild,v 1.3 2012/05/03 20:21:00 jdhore Exp $

EAPI=2
inherit multilib

DESCRIPTION="Syncmal plugin for jpilot"
HOMEPAGE="http://www.jlogday.com/code/syncmal/index.html"
SRC_URI="http://www.jlogday.com/code/syncmal/${P}.tar.gz"

LICENSE="GPL-2 MPL-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=app-pda/jpilot-0.99.9
	>=app-pda/pilot-link-0.12.3
	>=x11-libs/gtk+-2.8.19:2
	>=dev-libs/libmal-0.44"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		--enable-gtk2
}

src_install() {
	emake \
		DESTDIR="${D}" \
		libdir="/usr/$(get_libdir)/jpilot/plugins" \
		install || die

	dodoc AUTHORS README TODO

	find "${D}" -name '*.la' -delete
}
