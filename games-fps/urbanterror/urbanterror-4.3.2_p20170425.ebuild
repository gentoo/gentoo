# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic gnome2-utils

DESCRIPTION="Hollywood tactical shooter based on the ioquake3 engine"
HOMEPAGE="http://urbanterror.info"
SRC_URI="https://github.com/holgersson32644/ioq3/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/ioq3-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+altgamma +client +curl debug mumble openal +opus server +sdl voip vorbis"
REQUIRED_USE=" || ( client server )"

PATCHES=( "${FILESDIR}"/${P}-respect_CFLAGS.patch )

RDEPEND="
	curl? ( net-misc/curl )
	client? (
		virtual/opengl
		openal? ( media-libs/openal )
		sdl? ( media-libs/libsdl[X,sound,joystick,opengl,video] )
		!sdl? ( x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXxf86dga
			x11-libs/libXxf86vm )
		vorbis? ( media-libs/libogg
			media-libs/libvorbis )
		opus? ( media-libs/opusfile )
		mumble? ( media-sound/mumble )
		)
	~games-fps/urbanterror-data-4.3.2
	sys-libs/zlib[minizip]"
DEPEND="${RDEPEND}"

pkg_pretend() {
	if use client; then
		if ! use openal && ! use opus && ! use vorbis; then
			ewarn
			ewarn "Sound support disabled. Enable 'openal' or 'opus' or 'vorbis' useflag."
			ewarn
		fi
	fi
}

src_compile() {
	buildit() { use $1 && echo 1 || echo 0 ; }
	nobuildit() { use $1 && echo 0 || echo 1 ; }
	# unbundle zlib as much as possible
	append-flags "-DOF=_Z_OF"
	emake \
		ARCH=$(usex amd64 "x86_64" "i386") \
		DEFAULT_BASEDIR="/usr/share/urbanterror" \
		BUILD_CLIENT=$(buildit client) \
		BUILD_SERVER=$(buildit server) \
		BUILD_BASEGAME=1 \
		BUILD_MISSIONPACK=0 \
		BUILD_GAME_SO=0 \
		BUILD_GAME_QVM=0 \
		BUILD_STANDALONE=1 \
		SERVERBIN="Quake3-UrT-Ded" \
		CLIENTBIN="Quake3-UrT" \
		USE_RENDERER_DLOPEN=0 \
		USE_YACC=0 \
		BASEGAME="q3ut4"\
		BASEGAME_CFLAGS="${CFLAGS}" \
		USE_SDL=$(buildit sdl) \
		USE_SDL_DLOPEN=$(buildit sdl) \
		USE_OPENAL=$(buildit openal) \
		USE_OPENAL_DLOPEN=$(buildit openal) \
		USE_CURL=$(buildit curl) \
		USE_CURL_DLOPEN=$(buildit curl) \
		USE_CODEC_VORBIS=$(buildit vorbis) \
		USE_CODEC_OPUS=$(buildit opus) \
		USE_MUMBLE=$(buildit mumble) \
		USE_VOIP=$(buildit voip) \
		USE_INTERNAL_LIBS=0 \
		USE_LOCAL_HEADERS=0 \
		USE_ALTGAMMA=$(buildit altgamma)
}

src_install() {
	local my_arch=$(usex amd64 "x86_64" "i386")
	# docs from ioq3, not from UrbanTerror ZIP file
	dodoc ChangeLog README.md README.ioq3.md md4-readme.txt

	if use client; then
		newbin build/$(usex debug "debug" "release")-linux-${my_arch}/Quake3-UrT.${my_arch} ${PN}
		# Shooter as defined in https://specifications.freedesktop.org/menu-spec/latest/apas02.html
		make_desktop_entry ${PN} "UrbanTerror" ${PN}
	fi

	# means: dedicated server only
	if use server && ! use client; then
		newbin build/$(usex debug "debug" "release")-linux-${my_arch}/Quake3-UrT-Ded.${my_arch} ${PN}-ded
	fi
}
pkg_preinst() {
	use client && gnome2_icon_savelist
}

pkg_postinst() {
	use client && gnome2_icon_cache_update
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		if use openal; then
			einfo
			elog "You might need to set:"
			elog "  seta s_useopenal \"1\""
			elog "in your ~/.q3a/q3ut4/q3config.cfg for openal to work."
			einfo
		fi
		if use altgamma; then
			einfo
			elog "You might need to set:"
			elog "  seta r_altgamma \"1\""
			elog "in your ~/.q3a/q3ut4/q3config.cfg for altgamma to work."
			einfo
		fi
		if ! use altgamma; then
			einfo
			elog "If you are using a modesetting graphics driver you might"
			elog "consider setting USE=\"altgamma\"."
			elog "For details take a look on:"
			elog "https://bugs.freedesktop.org/show_bug.cgi?id=27222"
			einfo
		fi
		if ! use client; then
			einfo
			elog "You disabled client support. You won't be able to connect"
			elog "to any servers and play. If you want to do so, enable"
			elog "USE=\"client\"."
			einfo
		fi
	fi
}

pkg_postrm() {
	use client && gnome2_icon_cache_update
}
