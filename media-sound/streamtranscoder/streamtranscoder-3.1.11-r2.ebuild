# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AT_M4DIR=m4/

inherit autotools dot-a

MY_P="${PN}v3-${PV}"

DESCRIPTION="Commandline program to transcode shoutcast/icecast streams to different bitrates"
HOMEPAGE="http://www.oddsock.org/tools/streamTranscoderV3"
SRC_URI="http://www.oddsock.org/tools/streamTranscoderV3/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="
	media-libs/libogg
	media-libs/libvorbis
	media-sound/lame
	media-libs/libmad
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# should not be commented...
	sed -i 's/#AC_PROG_CXX/AC_PROG_CXX/' configure.in || die
	eautoreconf
}

src_configure() {
	lto-guarantee-fat
	default
}

src_install() {
	default
	strip-lto-bytecode
}
