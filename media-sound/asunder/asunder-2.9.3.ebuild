# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils

DESCRIPTION="A graphical Audio CD ripper and encoder with support for many output formats"
HOMEPAGE="http://littlesvr.ca/asunder/"
SRC_URI="http://littlesvr.ca/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
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

src_prepare() {
	default
	sed -i -e 's:cd syslogng && $(MAKE) install:true:' Makefile.in || die
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
