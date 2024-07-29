# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Command line MP3 player"
HOMEPAGE="http://konst.org.ua/en/orpheus"
SRC_URI="http://konst.org.ua/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="sys-libs/ncurses:0=
	media-libs/libvorbis
	media-sound/mpg123
	media-sound/vorbis-tools[ogg123]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/1.5-amd64.patch
	"${FILESDIR}"/101_fix-buffer-overflow.diff
	"${FILESDIR}"/${P}-fix-buildsystem.patch
	"${FILESDIR}"/${P}-cppflags.patch
	"${FILESDIR}"/${P}-bufsize.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-constify.patch
	"${FILESDIR}"/${P}-musl-stdint.patch
	"${FILESDIR}"/${P}-fix-build-w-clang-16.patch
)

src_prepare() {
	default

	cp config.rpath kkstrtext-0.1/ || die

	mv configure.{in,ac} || die
	mv kkstrtext-0.1/configure.{in,ac} || die
	mv kkconsui-0.1/configure.{in,ac} || die

	eautoreconf
}
