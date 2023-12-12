# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Hover hockey"
HOMEPAGE="http://home.no.net/munsuun/tuxpuck/"
SRC_URI="http://home.no.net/munsuun/tuxpuck/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl
	media-libs/libpng:0=
	media-libs/libvorbis
	virtual/jpeg:0"
DEPEND="${RDEPEND}
	media-libs/freetype:2"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-png15.patch
)

src_prepare() {
	default

	# Bug #376741 - Make unpack call compatible with both
	# PMS and <sys-apps/portage-2.1.10.10.
	cd man || die
	unpack ./${PN}.6.gz
}

src_configure() {
	tc-export AR CC PKG_CONFIG RANLIB
}

src_compile() {
	emake -C utils
	emake -C data
	emake
}

src_install() {
	dobin tuxpuck

	dodoc *.txt
	einstalldocs

	doman man/tuxpuck.6

	doicon data/icons/${PN}.ico
	make_desktop_entry ${PN} "TuxPuck" /usr/share/pixmaps/${PN}.ico
}
