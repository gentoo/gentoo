# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Hover hockey"
HOMEPAGE="http://home.no.net/munsuun/tuxpuck/"
SRC_URI="http://home.no.net/munsuun/tuxpuck/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl
	media-libs/libpng:0=
	virtual/jpeg:0
	media-libs/libvorbis
"
DEPEND="${RDEPEND}
	media-libs/freetype:2
	virtual/pkgconfig
"

src_prepare() {
	default
	# Bug #376741 - Make unpack call compatible with both
	# PMS and <sys-apps/portage-2.1.10.10.
	cd man || die
	unpack ./${PN}.6.gz
	cd .. || die
	sed -i \
		-e 's/-Werror//' \
		-e '/^CC/d' \
		Makefile \
		utils/Makefile \
		data/Makefile \
		|| die "sed failed"

	eapply "${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-png15.patch \
		"${FILESDIR}"/${P}-parallel.patch \
		"${FILESDIR}"/${P}-freetype_pkgconfig.patch
}

src_compile() {
	emake -C utils
	emake -C data
	emake
}

src_install() {
	dobin tuxpuck
	doman man/tuxpuck.6
	dodoc *.txt
	doicon data/icons/${PN}.ico
	make_desktop_entry ${PN} "TuxPuck" /usr/share/pixmaps/${PN}.ico
	einstalldocs
}
