# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3 toolchain-funcs flag-o-matic

DESCRIPTION="Command line media player for the Raspberry Pi"
HOMEPAGE="https://github.com/popcornmix/omxplayer"
EGIT_REPO_URI="https://github.com/popcornmix/omxplayer.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libpcre
	media-fonts/freefont
	|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin )
	sys-apps/dbus
	sys-apps/fbset
	virtual/ffmpeg
	x11-apps/xrefresh
	x11-apps/xset"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/Makefile-0_p20160217.patch \
		"${FILESDIR}"/fonts-path.patch

	cat > Makefile.include << EOF
LIBS=-lvchiq_arm -lvcos -lbcm_host -lEGL -lGLESv2 -lopenmaxil -lrt -lpthread
EOF

	tc-export CXX
}

src_compile() {
	emake omxplayer.bin
}

src_install() {
	dobin omxplayer omxplayer.bin
	dodoc README.md
}
