# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/jpilot/jpilot-1.8.1.ebuild,v 1.4 2014/03/01 22:17:19 mgorny Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="Desktop Organizer Software for the Palm Pilot"
HOMEPAGE="http://www.jpilot.org/"
SRC_URI="http://www.jpilot.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~x86"
IUSE="nls"

RDEPEND=">=app-pda/pilot-link-0.12.5
	dev-libs/libgcrypt:0
	>=x11-libs/gtk+-2.18.9:2"
DEPEND="${RDEPEND}
	nls? ( dev-util/intltool
		sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-char.patch
	mv -vf empty/Ma*anaDB.pdb empty/MananaDB.pdb || die

	sed -i \
		-e '/^Icon/s:jpilot.xpm:/usr/share/pixmaps/jpilot/jpilot-icon1.xpm:' \
		jpilot.desktop || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		icondir="/usr/share/pixmaps/${PN}" \
		miscdir="/usr/share/doc/${PF}" \
		install

	rm -f "${D}"/usr/share/doc/${PF}/{COPYING,INSTALL} \
		"${D}"/usr/share/pixmaps/${PN}/README

	find "${D}" -name '*.la' -exec rm -f {} +
}
