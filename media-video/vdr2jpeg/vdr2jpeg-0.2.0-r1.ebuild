# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERSION="1911" # every bump, new version

RESTRICT="strip"

DESCRIPTION="Addon needed for XXV - WWW Admin for the Video Disk Recorder"
HOMEPAGE="https://projects.vdr-developer.org/projects/xxv"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libav"

RDEPEND="
	libav? ( media-video/libav )
	!libav? ( media-video/ffmpeg:0 )
"
DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

DOCS=( README LIESMICH )

src_prepare() {
	sed -i Makefile \
		-e "s:usr/local:usr:" \
		-e "s:-o vdr2jpeg:\$(LDFLAGS) -o vdr2jpeg:" || die

	default
}

src_install() {
	if use libav; then
		emake DESTDIR="${D}" install FFMPEG_BIN=/usr/bin/avconv
	else
		emake DESTDIR="${D}" install FFMPEG_BIN=/usr/bin/ffmpeg
	fi

	einstalldocs
}
