# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

VERSION="1911" # every bump, new version

RESTRICT="strip"

DESCRIPTION="Addon needed for XXV - WWW Admin for the Video Disk Recorder"
HOMEPAGE="https://projects.vdr-developer.org/projects/xxv"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-video/ffmpeg:0"
DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

# bug 731212
QA_FLAGS_IGNORED="usr/bin/vdr2jpeg"

DOCS=( README LIESMICH )

src_prepare() {
	sed -i Makefile \
		-e "s:usr/local:usr:" \
		-e "s:-o vdr2jpeg:\$(LDFLAGS) -shared -o vdr2jpeg:" || die

	# bug 727640, 727804 do not call strip directly
	export  STRIP="$(tc-getSTRIP)"
	sed -i Makefile -e "s:-s vdr2jpeg:vdr2jpeg:" || die

	default
}

src_install() {
	emake DESTDIR="${D}" install FFMPEG_BIN=/usr/bin/ffmpeg

	einstalldocs
}
