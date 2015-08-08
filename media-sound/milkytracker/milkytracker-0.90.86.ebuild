# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# TODO: Unbundle dev-libs/zziplib!

inherit autotools eutils

DESCRIPTION="FastTracker 2 inspired music tracker"
HOMEPAGE="http://milkytracker.org/"
SRC_URI="http://milkytracker.org/files/${P}.tar.bz2"

LICENSE="|| ( GPL-3 MPL-1.1 ) AIFFWriter.m BSD GPL-3 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack"

RDEPEND=">=media-libs/libsdl-1.2:=[X]
	sys-libs/zlib:=
	alsa? ( media-libs/alsa-lib:= )
	jack? ( media-sound/jack-audio-connection-kit:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with alsa) \
		$(use_with jack)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS docs/{readme_unix,TiTAN.nfo}
	dohtml docs/{ChangeLog,FAQ,MilkyTracker}.html

	newicon resources/pictures/carton.png ${PN}.png
	make_desktop_entry ${PN} MilkyTracker ${PN} \
		"AudioVideo;Audio;Sequencer"
}
