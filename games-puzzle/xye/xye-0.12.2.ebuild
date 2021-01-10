# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools xdg

DESCRIPTION="Free version of the classic game Kye"
HOMEPAGE="http://xye.sourceforge.net/"
SRC_URI="mirror://sourceforge/xye/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-fonts/dejavu
	media-libs/libsdl[video]
	media-libs/sdl-ttf
	media-libs/sdl-image[png]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.2-fix-buildsystem.patch
	"${FILESDIR}"/${PN}-0.12.2-fix-c++14.patch
	"${FILESDIR}"/${PN}-0.12.2-fix-desktop-file.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	# create symlinks for previously bundled fonts
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf /usr/share/${PN}/res/DejaVuSans.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf /usr/share/${PN}/res/DejaVuSans-Bold.ttf
}
