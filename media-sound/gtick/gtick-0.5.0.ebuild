# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="a metronome application supporting different meters and speeds ranging"
HOMEPAGE="http://www.antcom.de/gtick"
SRC_URI="http://www.antcom.de/gtick/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE="nls sndfile"

RDEPEND="x11-libs/gtk+:2
	media-sound/pulseaudio
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

RESTRICT="test"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with sndfile)
}

src_install() {
	default
	newicon src/icon48x48.xpm ${PN}.xpm
	make_desktop_entry ${PN} "GTick"
}
