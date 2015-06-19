# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/gtkperf/gtkperf-0.40-r1.ebuild,v 1.1 2013/02/05 23:36:38 xmw Exp $

EAPI=5

inherit eutils

MY_P="${PN}_${PV}"
DESCRIPTION="Application designed to test GTK+ performance"
HOMEPAGE="http://gtkperf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	make_desktop_entry ${PN} ${PN} duck

	rm -rf "${D}/usr/doc" || die
	dodoc AUTHORS ChangeLog README TODO
}
