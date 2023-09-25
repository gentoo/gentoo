# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eapi8-dosym xdg

DESCRIPTION="Free version of the classic game Kye"
HOMEPAGE="https://xye.sourceforge.net/"
SRC_URI="mirror://sourceforge/xye/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-fonts/dejavu
	media-libs/libsdl[video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-buildsystem.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
	"${FILESDIR}"/${P}-fix-desktop-file.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	# create symlinks for previously bundled fonts
	dosym8 -r /usr/share/{fonts/dejavu,${PN}/res}/DejaVuSans.ttf
	dosym8 -r /usr/share/{fonts/dejavu,${PN}/res}/DejaVuSans-Bold.ttf
}
