# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="JACK client record button remembering the last 10 seconds when pressed"
HOMEPAGE="http://plugin.org.uk/timemachine/"
SRC_URI="http://plugin.org.uk/timemachine/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="lash"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.80
	x11-libs/gtk+:2
	>=media-libs/libsndfile-1.0.5
	media-libs/liblo
	lash? ( >=media-sound/lash-0.5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable lash)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog
}
