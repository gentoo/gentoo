# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit base eutils autotools games

DESCRIPTION="A new 3d engine based off of id Softwares's legendary Quake and QuakeWorld game engine"
HOMEPAGE="http://www.quakeforge.net/"
SRC_URI="mirror://sourceforge/quake/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="cdinstall debug fbcon opengl sdl svga X ncurses vorbis zlib ipv6 xv dga alsa oss"
RESTRICT="userpriv"

RDEPEND="
	opengl? ( virtual/opengl )
	sdl? ( media-libs/libsdl )
	svga? ( media-libs/svgalib )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
	)
	ncurses? ( sys-libs/ncurses )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	zlib? ( sys-libs/zlib )
	xv? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
	)
	dga? ( x11-libs/libXxf86dga )
	alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}
	cdinstall? ( games-fps/quake1-data )
	sys-devel/bison
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/${P}-no-page-size.patch
	"${FILESDIR}"/${PV}-ipv6.patch
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-keys.patch
	"${FILESDIR}"/${P}-amd64.patch
	"${FILESDIR}"/${P}-noWerror.patch
	"${FILESDIR}"/${P}-gcc46.patch
	"${FILESDIR}"/${P}-zlib-1.2.6.patch
	"${FILESDIR}"/${P}-libc.patch
)

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	#i should do this at some point :x ... i guess if you disable all shared stuff
	#and enable all the static options explicitly, static works ... (or so ive been told)
	#if ! use static ; then
	#	myconf="${myconf} --enable-shared=yes --enable-static=no"
	#else
	#	myconf="${myconf} --enable-shared=no --enable-static=yes"
	#fi

	local debugopts
	use debug \
		&& debugopts="--enable-debug --disable-optimize --enable-profile" \
		|| debugopts="--disable-debug --disable-profile"

	local clients=${QF_CLIENTS}
	use fbcon && clients="${clients},fbdev"
	use opengl && clients="${clients},glx"
	use sdl && clients="${clients},sdl,sdl32"
	use sdl && use opengl && clients="${clients},sgl"
	use svga && clients="${clients},svga"
	use X && clients="${clients},x11"
	use X && use opengl && clients="${clients},wgl"
	[ "${clients:0:1}" == "," ] && clients=${clients:1}

	local servers=${QF_SERVERS:-master,nq,qw,qtv}

	local tools=${QF_TOOLS:-all}

	local svgaconf	# use old school way for broken conf opts
	use svga \
		&& svgaconf="--with-svga=/usr" \
		|| svgaconf="--without-svga"

	addpredict "$(games_get_libdir)"
	egamesconf \
		$(use_enable ncurses curses) \
		$(use_enable vorbis) \
		$(use_enable zlib) \
		$(use_with ipv6) \
		$(use_with fbcon fbdev) \
		${svgaconf} \
		$(use_with X x) \
		$(use_enable xv vidmode) \
		$(use_enable dga) \
		$(use_enable sdl) \
		--disable-xmms \
		$(use_enable alsa) \
		$(use_enable oss) \
		--enable-sound \
		--disable-optimize \
		${debugopts} \
		--with-global-cfg="${GAMES_SYSCONFDIR}"/quakeforge.conf \
		--with-sharepath="${GAMES_DATADIR}"/quake1 \
		--with-clients=${clients} \
		--with-servers=${servers} \
		--with-tools=${tools}
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	mv "${D}/${GAMES_PREFIX}"/include "${D}"/usr/
	dodoc ChangeLog NEWS TODO doc/*txt
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
