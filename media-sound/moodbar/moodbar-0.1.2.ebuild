# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/moodbar/moodbar-0.1.2.ebuild,v 1.9 2012/05/05 08:38:38 mgorny Exp $

EAPI=2
inherit eutils

DESCRIPTION="The moodbar tool and gstreamer plugin for Amarok"
HOMEPAGE="http://amarok.kde.org/wiki/Moodbar"
SRC_URI="http://pwsp.net/~qbob/moodbar-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="mp3 ogg vorbis flac"

RDEPEND="media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-meta:0.10
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gthread_init.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
