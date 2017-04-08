# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic git-r3

DESCRIPTION="Hollywood tactical shooter based on the ioquake3 engine"
HOMEPAGE="http://urbanterror.info"
EGIT_REPO_URI="https://github.com/holgersson32644/ioq3.git"
EGIT_BRANCH="urt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+altgamma +curl debug dedicated mumble openal +opus server +sdl voip vorbis"
PATCHES=(
	"${FILESDIR}"/${P}-respect_CFLAGS.patch
)
RDEPEND="
	!dedicated? (
		virtual/opengl
		curl? ( net-misc/curl )
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
DEPEND="${RDEPEND}
	dedicated? ( curl? ( net-misc/curl ) )"

pkg_pretend() {
	if ! use dedicated ; then
		if ! use openal && ! use opus && ! use vorbis ; then
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
		BUILD_CLIENT=$(nobuildit dedicated) \
		BUILD_SERVER=$(usex dedicated "1" "$(buildit server)") \
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

	if use !dedicated ; then
		newbin build/$(usex debug "debug" "release")-linux-${my_arch}/Quake3-UrT.${my_arch} ${PN}
		# Shooter as defined in https://specifications.freedesktop.org/menu-spec/latest/apas02.html
		make_desktop_entry ${PN} "UrbanTerror" ${PN} Games;Shooter
	fi

	if use dedicated || use server ; then
		newbin build/$(usex debug "debug" "release")-linux-${my_arch}/Quake3-UrT-Ded.${my_arch} ${PN}-dedicated
	fi
}
pkg_preinst() {
	use dedicated || gnome2_icon_savelist
}

pkg_postinst() {
	use dedicated || gnome2_icon_cache_update
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		if use openal && ! use dedicated ; then
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
	fi
}

pkg_postrm() {
	use dedicated || gnome2_icon_cache_update
}
