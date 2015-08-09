# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnome2-utils cmake-utils eutils games

DESCRIPTION="A kart racing game starring Tux, the linux penguin (TuxKart fork)"
HOMEPAGE="http://supertuxkart.sourceforge.net/"
SRC_URI="mirror://sourceforge/supertuxkart/SuperTuxKart/${PV}/${P}-src.tar.bz2
	mirror://gentoo/${PN}.png"

LICENSE="GPL-3 CC-BY-SA-3.0 CC-BY-2.0 public-domain ZLIB"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug fribidi wiimote"

# don't unbundle irrlicht and bullet
# both are modified and system versions will break the game
# http://sourceforge.net/tracker/?func=detail&aid=3454889&group_id=74339&atid=540679

# VERSION BUMP NOTICE: enet might be needed for supertuxkart-0.9
RDEPEND="media-libs/freeglut
	media-libs/libpng:0
	media-libs/libvorbis
	media-libs/openal
	net-misc/curl
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	virtual/libintl
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXxf86vm
	fribidi? ( dev-libs/fribidi )
	wiimote? ( net-wireless/bluez )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/SuperTuxKart-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{gentoo,icon-dest,irrlicht,desktopfile,mesa-10.x,jpeg9,cmake}.patch

	# inconsistent handling of debug definition
	# avoid using Debug build type
	if use debug ; then
		sed -i \
			-e 's/add_definitions(-DNDEBUG)/add_definitions(-DDEBUG)/' \
			CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use fribidi FRIBIDI)
		$(cmake-utils_use_use wiimote WIIUSE)
		-DSTK_INSTALL_BINARY_DIR="${GAMES_BINDIR}"
		-DSTK_INSTALL_DATA_DIR="${GAMES_DATADIR}"/${PN}
	)

	cmake-utils_src_configure
}

src_compile() {
	# build bundled irrlicht
	NDEBUG=1 emake -C lib/irrlicht/source/Irrlicht

	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	doicon -s 64 "${DISTDIR}"/${PN}.png
	dodoc AUTHORS ChangeLog README TODO
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
