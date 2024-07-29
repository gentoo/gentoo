# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

GIT_COMMIT="791d7df"
DESCRIPTION="Command line media player for the Raspberry Pi"
HOMEPAGE="https://github.com/popcornmix/omxplayer"
SRC_URI="https://github.com/popcornmix/omxplayer/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE="X"

RDEPEND="dev-libs/libpcre
	media-fonts/freefont
	|| ( media-libs/raspberrypi-userland media-libs/raspberrypi-userland-bin )
	sys-apps/dbus
	sys-apps/fbset
	media-video/ffmpeg
	dev-libs/boost
	media-libs/freetype:2
	X? (
		x11-apps/xrefresh
		x11-apps/xset
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/Makefile-0_p20160528.patch
	"${FILESDIR}"/fonts-path.patch
	"${FILESDIR}"/cross-0_p20160528.patch
)

DOCS=( README.md )

S="${WORKDIR}/popcornmix-omxplayer-${GIT_COMMIT}"

src_prepare() {
	default
	cat > Makefile.include << EOF
LIBS=-lvchostif -lvchiq_arm -lvcos -lbcm_host -lEGL -lGLESv2 -lopenmaxil -lrt -lpthread
EOF

	tc-export CXX PKG_CONFIG
}

src_compile() {
	emake omxplayer.bin
}

src_install() {
	dobin omxplayer omxplayer.bin
	einstalldocs
}
