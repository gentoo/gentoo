# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Puzzle game similar to Oxyd"
HOMEPAGE="http://www.nongnu.org/enigma/"
SRC_URI="https://github.com/Enigma-Game/Enigma/releases/download/${PV}/Enigma-${PV}-src.tar.gz"

LICENSE="GPL-2+ non-free? ( all-rights-reserved )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls non-free"
RESTRICT="mirror non-free? ( bindist )"

DEPEND="
	dev-libs/xerces-c:=
	media-libs/libpng:0=
	media-libs/libsdl2[video]
	media-libs/sdl2-image[jpeg,png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf
	net-libs/enet:=
	net-misc/curl
	sys-libs/zlib
	non-free? ( media-libs/sdl2-mixer[mod] )
"
RDEPEND="
	${DEPEND}
	media-fonts/dejavu
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-no-gettext.patch
	"${FILESDIR}"/${P}-build.patch
)

DOCS=(
	ACKNOWLEDGEMENTS
	AUTHORS
	CHANGES
	README
	doc/HACKING
)

src_prepare() {
	default
	rm -r intl/ || die
	eautoreconf
	config_rpath_update .
}

src_configure() {
	# After patching, all docs are HTML. The game itself uses docdir, and
	# overriding it here is the easiest way to handle this.
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--with-system-enet \
		$(use_enable nls)
}

src_install() {
	default
	doman doc/${PN}.6

	dosym \
		../../fonts/dejavu/DejaVuSansCondensed.ttf \
		/usr/share/${PN}/fonts/DejaVuSansCondensed.ttf
	dosym \
		../../fonts/dejavu/DejaVuSans.ttf \
		/usr/share/${PN}/fonts/vera_sans.ttf

	if ! use non-free; then
		# Informal permission was given by this track's author, but there is no
		# formal license, and the file includes an All Rights Reserved notice.
		rm -v "${ED}"/usr/share/${PN}/music/menu/pentagonal_dreams.s3m || die
	fi
}
