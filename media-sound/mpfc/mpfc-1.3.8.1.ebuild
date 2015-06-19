# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpfc/mpfc-1.3.8.1.ebuild,v 1.2 2011/06/08 09:56:05 flameeyes Exp $

EAPI=2

DESCRIPTION="Music Player For Console"
HOMEPAGE="http://mpfc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa flac gpm mad vorbis oss wav cdda nls"

RDEPEND="alsa? ( >=media-libs/alsa-lib-0.9.0 )
	flac? ( media-libs/flac )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	sys-libs/ncurses[unicode]
	dev-libs/icu"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable alsa) \
		$(use_enable flac) \
		$(use_enable gpm) \
		$(use_enable mad mp3) \
		$(use_enable vorbis ogg) \
		$(use_enable oss) \
		$(use_enable wav) \
		$(use_enable cdda audiocd) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die

	insinto /etc
	doins mpfcrc || die

	dodoc AUTHORS ChangeLog NEWS README || die
}
