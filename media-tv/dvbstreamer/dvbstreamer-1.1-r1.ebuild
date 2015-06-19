# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/dvbstreamer/dvbstreamer-1.1-r1.ebuild,v 1.4 2012/02/15 18:34:36 hd_brummy Exp $

EAPI=2
inherit autotools eutils multilib

DESCRIPTION="DVB over UDP streaming solution"
HOMEPAGE="http://dvbstreamer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-db/sqlite:3
	sys-libs/readline
	>=sys-devel/libtool-2.2.6"
DEPEND="${RDEPEND}
	virtual/linuxtv-dvb-headers"

src_prepare() {
	rm -rf libltdl
	epatch "${FILESDIR}"/${P}-Werror.patch \
		"${FILESDIR}"/${P}-libtool.patch
	eautoreconf
}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir)
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm -rf "${D}"/usr/doc

	dodoc doc/*.txt ChangeLog README AUTHORS NEWS TODO
}
