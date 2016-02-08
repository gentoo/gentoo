# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Command line MP3 player"
HOMEPAGE="http://konst.org.ua/en/orpheus"
SRC_URI="http://konst.org.ua/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0=
	media-libs/libvorbis
	media-sound/mpg123
	media-sound/vorbis-tools[ogg123]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/1.5-amd64.patch"
	"${FILESDIR}/101_fix-buffer-overflow.diff"
	"${FILESDIR}/${P}-fix-buildsystem.patch"
	"${FILESDIR}/${P}-cppflags.patch"
	"${FILESDIR}/${P}-bufsize.patch"
	"${FILESDIR}/${P}-gcc47.patch"
	"${FILESDIR}/${P}-constify.patch"
)

src_prepare() {
	# rename all configure.in files to prevent future
	# autoconf breakage
	local i
	for i in "" "kkstrtext-0.1" "kkconsui-0.1"
	do
		mv ./${i}/configure.{in,ac} || die
	done

	default
	cp "${S}"/{config.rpath,kkstrtext-0.1} || die

	eautoreconf
}
