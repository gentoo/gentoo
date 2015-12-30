# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools games

DESCRIPTION="new 3d engine based off of id Softwares's Quake and QuakeWorld game engine"
HOMEPAGE="http://www.quakeforge.net/"
SRC_URI="mirror://sourceforge/quake/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cdinstall debug fbcon flac sdl X ncurses png vorbis zlib ipv6 xv dga alsa oss xdg wildmidi"
RESTRICT="userpriv"

RDEPEND="
	media-libs/libsamplerate
	net-misc/curl
	virtual/opengl
	png? ( media-libs/libpng:0 )
	flac? ( media-libs/flac )
	sdl? ( media-libs/libsdl[video] )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
	)
	ncurses? ( sys-libs/ncurses:0 )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	zlib? ( sys-libs/zlib )
	xv? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
	)
	dga? ( x11-libs/libXxf86dga )
	alsa? ( media-libs/alsa-lib )
	wildmidi? ( media-sound/wildmidi )"
DEPEND="${RDEPEND}
	cdinstall? ( games-fps/quake1-data )
	>=sys-devel/bison-2.6
	sys-devel/flex
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_configure() {
	local debugopts
	use debug \
		&& debugopts="--enable-debug --disable-optimize --enable-profile" \
		|| debugopts="--disable-debug --disable-profile"

	local clients=${QF_CLIENTS}
	use fbcon && clients="${clients},fbdev"
	use sdl && clients="${clients},sdl"
	use X && clients="${clients},x11"
	[ "${clients:0:1}" == "," ] && clients=${clients:1}

	local servers=${QF_SERVERS:-master,nq,qw,qtv}

	local tools=${QF_TOOLS:-all}

	egamesconf \
		--enable-dependency-tracking \
		$(use_enable ncurses curses) \
		$(use_enable vorbis) \
		$(use_enable png) \
		$(use_enable zlib) \
		$(use_with ipv6) \
		$(use_with fbcon fbdev) \
		$(use_with X x) \
		$(use_enable xv vidmode) \
		$(use_enable dga) \
		$(use_enable sdl) \
		--disable-xmms \
		$(use_enable alsa) \
		$(use_enable flac) \
		$(use_enable oss) \
		$(use_enable xdg) \
		$(use_enable wildmidi) \
		--enable-sound \
		--disable-optimize \
		--disable-Werror \
		--without-svga \
		${debugopts} \
		--with-global-cfg="${GAMES_SYSCONFDIR}"/quakeforge.conf \
		--with-sharepath="${GAMES_DATADIR}"/quake1 \
		--with-clients=${clients} \
		--with-servers=${servers} \
		--with-tools=${tools}
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	mv "${D}/${GAMES_PREFIX}"/include "${D}"/usr/ || die
	dodoc ChangeLog NEWS TODO
	prepgamesdirs
}

pkg_postinst() {
	# same warning used in quake1 / quakeforge / nprquake-sdl
	games_pkg_postinst
	echo
	elog "Before you can play, you must make sure"
	elog "${PN} can find your Quake .pak files"
	elog
	elog "You have 2 choices to do this"
	elog "1 Copy pak*.pak files to ${GAMES_DATADIR}/quake1/id1"
	elog "2 Symlink pak*.pak files in ${GAMES_DATADIR}/quake1/id1"
	elog
	elog "Example:"
	elog "my pak*.pak files are in /mnt/secondary/Games/Quake/Id1/"
	elog "ln -s /mnt/secondary/Games/Quake/Id1/pak0.pak ${GAMES_DATADIR}/quake1/id1/pak0.pak"
	elog
	elog "You only need pak0.pak to play the demo version,"
	elog "the others are needed for registered version"
}
