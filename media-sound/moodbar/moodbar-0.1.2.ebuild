# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="The moodbar tool and gstreamer plugin for Amarok"
HOMEPAGE="https://amarok.kde.org/wiki/Moodbar"
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
