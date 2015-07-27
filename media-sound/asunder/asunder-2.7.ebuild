# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/asunder/asunder-2.7.ebuild,v 1.1 2015/07/27 15:03:05 polynomial-c Exp $

EAPI=5

DESCRIPTION="A graphical Audio CD ripper and encoder with support for WAV, MP3, OggVorbis, FLAC and Opus"
HOMEPAGE="http://littlesvr.ca/asunder/"
SRC_URI="http://littlesvr.ca/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac flac mac mp3 musepack opus vorbis wavpack"

COMMON_DEPEND=">=media-libs/libcddb-0.9.5
	media-sound/cdparanoia
	x11-libs/gtk+:2"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"
RDEPEND="${COMMON_DEPEND}
	aac? ( media-sound/neroaac )
	flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	mp3? ( media-sound/lame )
	musepack? ( media-sound/musepack-tools )
	opus? ( media-sound/opus-tools )
	vorbis? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack )"

DOCS="AUTHORS ChangeLog README TODO" # NEWS is dummy

src_prepare() {
	sed -i -e 's:cd syslogng && $(MAKE) install:true:' "${S}"/Makefile.in
}
