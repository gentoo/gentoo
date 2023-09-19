# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic xdg

MY_P="${P}-linux20130827"

DESCRIPTION="Fast-paced multiplayer deathmatch game"
HOMEPAGE="http://red.planetarena.org/"
SRC_URI="
	http://icculus.org/alienarena/Files/${MY_P}.tar.gz
	http://red.planetarena.org/files/${MY_P}.tar.gz"

LICENSE="GPL-2 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated +dga +vidmode +zlib"

RDEPEND="
	!dedicated? (
		media-libs/freetype:2
		media-libs/libvorbis
		media-libs/openal
		net-misc/curl
		virtual/glu
		virtual/jpeg:0
		virtual/opengl
		dga? ( x11-libs/libXxf86dga )
		vidmode? ( x11-libs/libXxf86vm )
		zlib? ( sys-libs/zlib )
	)"
DEPEND="${RDEPEND}
	!dedicated? (
		dga? ( x11-base/xorg-proto )
		vidmode? ( x11-base/xorg-proto )
	)"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
	"${FILESDIR}"/${P}-ar.patch
	"${FILESDIR}"/${P}-C99-inline.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# too many variables defined in .h to patch, https://bugs.gentoo.org/707814
	append-cflags -fcommon

	econf \
		--with-icondir="${EPREFIX}/usr/share/icons/hicolor/48x48/apps/" \
		--without-system-libode \
		--disable-documents \
		$(use_enable !dedicated client) \
		$(use_with zlib) \
		$(use_with vidmode xf86vm) \
		$(use_with dga xf86dga)
}

src_install() {
	DOCS=( docs/README.txt README )
	default

	use !dedicated && make_desktop_entry ${PN} "Alien Arena"
}
