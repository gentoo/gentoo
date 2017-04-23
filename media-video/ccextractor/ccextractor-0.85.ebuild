# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs cmake-utils

DESCRIPTION="Extract closed captioning subtitles from video to SRT"
HOMEPAGE="http://ccextractor.sourceforge.net/"
SRC_URI="mirror://sourceforge/ccextractor/${PN}-src-nowin.${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

S="${WORKDIR}/${PN}/src"

PATCHES=(
	"${FILESDIR}/zlib.patch"
	"${FILESDIR}/cflags.patch"
)

src_prepare() {
	rm -rf libpng zlib || die
	cmake-utils_src_prepare
}
