# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 luajit )

inherit lua-single xdg-utils

DESCRIPTION="A 2D space trading and combat game, in a similar vein to Escape Velocity"
HOMEPAGE="https://naev.org/ https://github.com/naev/naev"
SRC_URI="https://github.com/naev/naev/releases/download/v${PV}/${P}.tar.bz2
	https://github.com/naev/naev/releases/download/v${PV}/${P}-ndata.zip"

LICENSE="GPL-2 GPL-3 public-domain CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +mixer +openal"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	media-libs/libsdl2[X,sound,video]
	dev-libs/libzip
	dev-libs/libxml2
	>=media-libs/freetype-2:2
	>=media-libs/libvorbis-1.2.1
	>=media-libs/libpng-1.2:0=
	virtual/glu
	virtual/opengl
	mixer? ( media-libs/sdl2-mixer )
	openal? ( media-libs/openal )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

# This is so that only the source tarball is unpacked - the data file
# is supposed to be installed *zipped*. This is why we do not need unzip
# in BDEPEND in spite of what repoman/pkgcheck might say.
src_unpack() {
	unpack ${P}.tar.bz2
}

src_configure() {
	econf \
		--enable-lua=$(usex lua_single_target_luajit luajit shared) \
		$(use_enable debug) \
		$(use_with openal) \
		$(use_with mixer sdlmixer)
}

src_compile() {
	emake V=1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		appicondir=/usr/share/pixmaps \
		appdatadir=/usr/share/metainfo \
		Graphicsdir=/usr/share/applications \
		install
	insinto /usr/share/${PN}
	newins "${DISTDIR}/${P}-ndata.zip" ndata

	rm -f "${D}/usr/share/doc/${PF}/LICENSE"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
