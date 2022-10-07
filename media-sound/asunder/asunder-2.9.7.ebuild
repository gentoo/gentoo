# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Graphical Audio CD ripper and encoder with support for many output formats"
HOMEPAGE="http://littlesvr.ca/asunder/"
SRC_URI="http://littlesvr.ca/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="flac mac mp3 musepack opus vorbis wavpack"

BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
DEPEND="media-libs/libcddb
	media-sound/cdparanoia
	x11-libs/gtk+:2"
# dlopen() deps
RDEPEND="${DEPEND}
	flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	mp3? ( media-sound/lame )
	musepack? ( media-sound/musepack-tools )
	opus? ( media-sound/opus-tools )
	vorbis? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack )"

src_prepare() {
	default
	sed -i -e 's:cd syslogng && $(MAKE) install:true:' Makefile.in || die
}
