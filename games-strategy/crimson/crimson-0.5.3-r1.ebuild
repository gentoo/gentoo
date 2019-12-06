# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Tactical war game in the tradition of Battle Isle"
HOMEPAGE="http://crimson.seul.org/"
SRC_URI="http://crimson.seul.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/sdl-net
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	test? (
		app-text/docbook-xml-dtd:4.2
		dev-libs/libxml2
	)
"

src_configure() {
	econf \
		--enable-sound \
		--enable-network \
		$(use_with zlib) \
		--enable-cfed \
		--enable-bi2cf \
		--enable-comet \
		--enable-cf2bmp
}

src_install() {
	emake \
		DESTDIR="${D}" \
		pixmapsdir="/usr/share/pixmaps" \
		install
	einstalldocs
	rm -rf "${ED}/usr/share/applications"
	make_desktop_entry crimson "Crimson Fields"
}
