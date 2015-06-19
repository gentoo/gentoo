# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/dvbstreamer/dvbstreamer-2.0.0_rc1.ebuild,v 1.2 2012/02/15 18:34:36 hd_brummy Exp $

EAPI=2
MY_P=${P/_}

DESCRIPTION="DVB over UDP streaming solution"
HOMEPAGE="http://dvbstreamer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3
	dev-libs/libev
	dev-libs/libyaml
	>=sys-devel/libtool-2.2.6b
	sys-libs/readline"
DEPEND="${RDEPEND}
	virtual/linuxtv-dvb-headers"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-file-streamer
}

src_install() {
	emake DESTDIR="${D}" dvbstreamerdocdir="/usr/share/doc/${PF}" install || die
	dodoc doc/*.txt
	prepalldocs
}
