# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils check-reqs toolchain-funcs games

# Switch to ^ when we switch to EAPI=6.
MY_PN="X${PN:1}"
DESCRIPTION="Fork of Nexuiz, Deathmatch FPS based on DarkPlaces, an advanced Quake 1 engine"
HOMEPAGE="http://www.xonotic.org/"
SRC_URI="http://dl.xonotic.org/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa debug dedicated doc ode sdl"

UIRDEPEND="
	media-libs/libogg
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/libmodplug
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libXdmcp
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	virtual/opengl
	media-libs/freetype:2
	alsa? ( media-libs/alsa-lib )
	ode? ( dev-games/ode[double-precision] )
	sdl? ( media-libs/libsdl[X,sound,joystick,opengl,video,alsa?] )"
UIDEPEND="
	x11-proto/xextproto
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	x11-proto/xproto"
RDEPEND="
	sys-libs/zlib
	virtual/jpeg:0
	media-libs/libpng:0
	net-misc/curl
	~dev-libs/d0_blind_id-0.5
	!dedicated? ( ${UIRDEPEND} )"
DEPEND="${RDEPEND}
	!dedicated? ( ${UIDEPEND} )"

CHECKREQS_DISK_BUILD="1200M"
CHECKREQS_DISK_USR="950M"

S=${WORKDIR}/${MY_PN}

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
	games_pkg_setup
}

src_prepare() {
	sed -i \
		-e "/^EXE_/s:darkplaces:${PN}:" \
		-e "s:-O3:${CFLAGS}:" \
		-e "/-lm/s:$: ${LDFLAGS}:" \
		-e '/^STRIP/s/strip/true/' \
		source/darkplaces/makefile.inc || die

	if ! use alsa; then
		sed -i \
			-e "/DEFAULT_SNDAPI/s:ALSA:OSS:" \
			source/darkplaces/makefile || die
	fi
}

src_compile() {
	local t="$(use debug && echo debug || echo release)"
	local i

	tc-export CC CXX LD AR RANLIB

	# use a for-loop wrt bug 473352
	for i in sv-${t} $(use !dedicated && echo "cl-${t} $(use sdl && echo sdl-${t})") ; do
		emake \
			-C source/darkplaces \
			DP_LINK_ODE=$(usex ode shared no) \
			DP_FS_BASEDIR="${GAMES_DATADIR}/${PN}" \
			${i}
	done
}

src_install() {
	if ! use dedicated; then
		dogamesbin source/darkplaces/${PN}-glx
		newicon misc/logos/${PN}_icon.svg ${PN}.svg
		make_desktop_entry ${PN}-glx "${MY_PN} (GLX)"

		if use sdl; then
			dogamesbin source/darkplaces/${PN}-sdl
			make_desktop_entry ${PN}-sdl "${MY_PN} (SDL)"
		fi
	fi
	dogamesbin source/darkplaces/${PN}-dedicated

	dodoc Docs/*.txt
	use doc && dohtml -r Docs

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r key_0.d0pk server data
	prepgamesdirs

	elog "If you are using opensource drivers you should consider installing: "
	elog "    media-libs/libtxc_dxtn"
}
