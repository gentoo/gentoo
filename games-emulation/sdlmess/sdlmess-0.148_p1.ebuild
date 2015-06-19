# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/sdlmess/sdlmess-0.148_p1.ebuild,v 1.7 2015/06/02 04:36:18 mr_bones_ Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils flag-o-matic python-any-r1 games

MY_PV=${PV/.}
MY_CONF_PN=${PN/sdl}
MY_P=sdlmame${MY_PV}
MY_P=${MY_P%%_p*}
MY_CONF_VER="0.148"

# patches
SRC_URI="$(for PATCH_VER in $(seq 1 ${PV##*_p}) ; do echo "http://dev.gentoo.org/~hasufell/distfiles/${MY_P}u${PATCH_VER}_diff.zip"; done)"

DESCRIPTION="Multi Emulator Super System (SDL)"
HOMEPAGE="http://mamedev.org/"
# Upstream doesn't allow fetching with unknown User-Agent such as wget
SRC_URI="$SRC_URI http://dev.gentoo.org/~hasufell/distfiles/${MY_P/sdl}s.zip"
if [[ ${PN} == "sdlmame" ]] ; then
	SRC_URI="$SRC_URI http://www.netswarm.net/misc/sdlmame-ui.bdf.gz"
fi

LICENSE="XMAME"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X debug opengl"
REQUIRED_USE="debug? ( X )"

RDEPEND="dev-libs/expat
	media-libs/fontconfig
	media-libs/flac
	>=media-libs/libsdl-1.2.10[sound,joystick,opengl?,video]
	media-libs/sdl-ttf
	sys-libs/zlib
	virtual/jpeg:0
	media-libs/portmidi
	X? (
		gnome-base/gconf
		x11-libs/gtk+:2
		x11-libs/libX11
		x11-libs/libXinerama
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-arch/unzip
	virtual/pkgconfig
	X? ( x11-proto/xineramaproto )"

S=${WORKDIR}

# Function to disable a makefile option
disable_feature() {
	sed -i \
		-e "/$1.*=/s:^:# :" \
		"${S}"/makefile \
		|| die "sed failed"
}

# Function to enable a makefile option
enable_feature() {
	sed -i \
		-e "/^#.*$1.*=/s:^#::"  \
		"${S}"/${2:-makefile} \
		|| die "sed failed"
}

pkg_setup() {
	games_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	default
	unpack ./mame.zip
	rm -f mame.zip
}

src_prepare() {
	if [[ $PV == *_p* ]] ; then
		edos2unix $(find $(grep +++ *diff | awk '{ print $2 }' | sort -u) 2>/dev/null) *diff
		einfo "Patching release with source updates"
		epatch ${MY_PV%%_p*}*.diff
	fi
	edos2unix src/osd/sdl/osdsdl.h

	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-no-opengl.patch

	# Don't compile zlib and expat
	einfo "Disabling embedded libraries: expat, flac, jpeg, portmidi, zlib"
	disable_feature BUILD_EXPAT
	disable_feature BUILD_FLAC
	disable_feature BUILD_JPEG
	disable_feature BUILD_MIDILIB
	disable_feature BUILD_ZLIB

	if use amd64; then
		einfo "Enabling 64-bit support"
		enable_feature PTR64
	fi

	if use ppc; then
		einfo "Enabling PPC support"
		enable_feature BIGENDIAN
	fi

	if use debug; then
		einfo "Enabling debug support"
		enable_feature DEBUG
	fi

	if ! use opengl ; then
		einfo "Disabling opengl support"
		enable_feature NO_OPENGL src/osd/sdl/sdl.mak
	fi

	if ! use X ; then
		einfo "Disabling X support"
		enable_feature NO_X11 src/osd/sdl/sdl.mak
	fi
}

src_compile() {
	emake \
		TARGET="${PN#sdl}" \
		NAME="${PN}" \
		OPT_FLAGS='-DINI_PATH=\"\$$HOME/.'${PN}'\;'"${GAMES_SYSCONFDIR}/${PN}"'\"' \
		NO_DEBUGGER=$(usex debug "0" "1") default
}

src_install() {
	newgamesbin ${PN}$(use amd64 && echo 64)$(use debug && echo d) ${PN}

	newman src/osd/sdl/man/${PN#sdl}.6 ${PN}.6

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r src/osd/sdl/keymaps
	[[ ${PN} == "sdlmame" ]] && newins sdlmame-ui.bdf ui.bdf

	insinto "${GAMES_SYSCONFDIR}/${PN}"
	doins "${FILESDIR}"/vector.ini

	sed \
		-e "s:@GAMES_SYSCONFDIR@:${GAMES_SYSCONFDIR}:" \
		-e "s:@GAMES_DATADIR@:${GAMES_DATADIR}:" \
		"${FILESDIR}/${MY_CONF_PN}-${MY_CONF_VER}".ini.in > "${D}/${GAMES_SYSCONFDIR}/${PN}/${MY_CONF_PN}".ini \
		|| die "sed failed"

	dodoc docs/{config,mame,newvideo}.txt
	if [[ ${PN} == "sdlmame" ]] ; then
		dodoc whatsnew*.txt
	else
		dodoc messnew*.txt
	fi

	keepdir \
		"${GAMES_DATADIR}/${PN}"/{ctrlr,cheats,roms,samples,artwork,crosshair} \
		"${GAMES_SYSCONFDIR}/${PN}"/{ctrlr,cheats}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "optional dependencies:"
	elog "  games-emulation/sdlmametools (development tools)"
	echo
	elog "It's strongly recommended that you change either the system-wide"
	elog "${MY_CONF_PN}.ini at \"${GAMES_SYSCONFDIR}/${PN}\" or use a per-user setup at \$HOME/.${PN}"

	if use opengl; then
		echo
		elog "You built ${PN} with opengl support and should set"
		elog "\"video\" to \"opengl\" in ${MY_CONF_PN}.ini to take advantage of that"
	fi
}
