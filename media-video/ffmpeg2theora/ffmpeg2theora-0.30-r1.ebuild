# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit python-any-r1 scons-utils

DESCRIPTION="A simple converter to create Ogg Theora files"
HOMEPAGE="http://www.v2v.cc/~j/ffmpeg2theora/"
SRC_URI="http://www.v2v.cc/~j/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="kate"

RDEPEND="
	media-video/ffmpeg:0=[postproc]
	>=media-libs/libvorbis-1.1
	>=media-libs/libogg-1.1
	>=media-libs/libtheora-1.1[encode]
	kate? ( >=media-libs/libkate-0.3.7 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.29-swr.patch
	"${FILESDIR}"/${PN}-0.29-underlinking.patch
)

src_prepare() {
	default

	2to3 -n -w --no-diffs SConstruct || die
}

src_configure() {
	SCONSARGS=(
		APPEND_CCFLAGS="${CFLAGS}"
		APPEND_LINKFLAGS="${LDFLAGS}"
		prefix=/usr
		mandir=PREFIX/share/man
		libkate=$(usex kate 1 0)
	)
}

src_compile() {
	escons "${SCONSARGS[@]}"
}

src_install() {
	escons "${SCONSARGS[@]}" destdir="${D}" install
	dodoc AUTHORS ChangeLog README subtitles.txt TODO
}
