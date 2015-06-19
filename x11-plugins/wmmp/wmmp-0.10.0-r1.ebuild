# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmp/wmmp-0.10.0-r1.ebuild,v 1.6 2010/09/06 09:48:58 s4t4n Exp $

EAPI=2
MY_P=${P/wm/WM}

DESCRIPTION="A Window Maker dock app client for Music Player Daemon(media-sound/mpd)"
HOMEPAGE="http://mpd.wikia.com/wiki/Client:WMmp"
SRC_URI="mirror://sourceforge/musicpd/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf --with-default-port=6600
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" || die "make failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README THANKS TODO
}
