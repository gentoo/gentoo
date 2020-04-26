# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

VERSION="1911" # every bump, new version

RESTRICT="strip"

DESCRIPTION="Addon needed for XXV - WWW Admin for the Video Disk Recorder"
HOMEPAGE="https://projects.vdr-developer.org/projects/xxv"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz
		mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-video/ffmpeg:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -i \
		-e "s:usr/local:usr:" \
		-e "s:-o vdr2jpeg:\$(LDFLAGS) -o vdr2jpeg:" \
		Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install FFMPEG_BIN=/usr/bin/ffmpeg

	dodoc README LIESMICH
}
