# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit check-reqs eutils gnome2-utils pax-utils games

ENGINE_PV=${PV}
FULL_P=UrbanTerror42_full022
UPDATE_PV=${PV:0:3}.${FULL_P#*full}
DESCRIPTION="Hollywood tactical shooter based on the ioquake3 engine"
HOMEPAGE="http://www.urbanterror.info/home/"
SRC_URI="http://up.barbatos.fr/urt/${FULL_P}.zip
	https://github.com/Barbatos/ioq3-for-UrbanTerror-4/archive/release-${ENGINE_PV}.tar.gz -> ${PN}-${ENGINE_PV}.tar.gz
	http://upload.wikimedia.org/wikipedia/en/5/56/Urbanterror.svg -> ${PN}.svg"

# fetch updates
if [[ ${FULL_P#*full} != ${PV#*.} ]] ; then
	UPDATE_I=${UPDATE_PV:5:2}
	while [[ ${UPDATE_I} -lt ${PV:5:2} ]] ; do
		SRC_URI="${SRC_URI} http://up.barbatos.fr/urt/UrbanTerror-${PV:0:5}${UPDATE_I}-to-${PV:0:5}$(( ${UPDATE_I} + 1)).zip"
		UPDATE_I=$(( ${UPDATE_I} + 1))
	done
fi
unset UPDATE_I

LICENSE="GPL-2 Q3AEULA-20000111 urbanterror-4.2-maps"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+altgamma +curl debug dedicated openal pax_kernel +sdl server smp vorbis"
RESTRICT="mirror"

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
	)"
DEPEND="${RDEPEND}
	app-arch/unzip
	dedicated? ( curl? ( net-misc/curl ) )"

S=${WORKDIR}/ioq3-for-UrbanTerror-4-release-${ENGINE_PV}
S_DATA=${WORKDIR}/UrbanTerror42

CHECKREQS_DISK_BUILD="3300M"
CHECKREQS_DISK_USR="1550M"

pkg_pretend() {
	check-reqs_pkg_pretend

	if ! use dedicated ; then
		if ! use sdl && ! use openal ; then
			ewarn
			ewarn "Sound support disabled. Enable 'sdl' or 'openal' useflag."
			ewarn
		fi
	fi
}

src_unpack() {
	local UPDATE_I
	default
	# apply updates
	if [[ ${FULL_P#*full} != ${PV##*.} ]] ; then
		UPDATE_I=${UPDATE_PV:5:2}
		while [[ ${UPDATE_I} -lt ${PV:5:2} ]] ; do
			cp -dRpf \
				"${WORKDIR}"/UrbanTerror-${PV:0:5}${UPDATE_I}-to-${PV:0:5}$((${UPDATE_I} + 1))/* \
				"${S_DATA}"/ || die
			UPDATE_I=$(( ${UPDATE_I} + 1))
		done
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${ENGINE_PV}-build.patch
}

src_compile() {
	buildit() { use $1 && echo 1 || echo 0 ; }
	nobuildit() { use $1 && echo 0 || echo 1 ; }

	emake \
		ARCH=$(usex amd64 "x86_64" "i386") \
		DEFAULT_BASEDIR="${GAMES_DATADIR}/${PN}" \
		BUILD_CLIENT=$(nobuildit dedicated) \
		BUILD_CLIENT_SMP=$(usex smp "$(nobuildit dedicated)" "0") \
		BUILD_SERVER=$(usex dedicated "1" "$(buildit server)") \
		USE_SDL=$(buildit sdl) \
		USE_OPENAL=$(buildit openal) \
		USE_OPENAL_DLOPEN=0 \
		USE_CURL=$(buildit curl) \
		USE_CURL_DLOPEN=0 \
		USE_CODEC_VORBIS=$(buildit vorbis) \
		USE_ALTGAMMA=$(buildit altgamma) \
		USE_LOCAL_HEADERS=0 \
		Q="" \
		$(usex debug "debug" "release")
}

src_install() {
	local my_arch=$(usex amd64 "x86_64" "i386")

	dodoc ChangeLog README md4-readme.txt
	dodoc "${S_DATA}"/q3ut4/readme42.txt
	insinto "${GAMES_DATADIR}"/${PN}/q3ut4
	doins "${S_DATA}"/q3ut4/*.pk3

	if use !dedicated ; then
		newgamesbin build/$(usex debug "debug" "release")-linux-${my_arch}/Quake3-UrT$(usex smp "-smp" "").${my_arch} ${PN}
		doicon -s scalable "${DISTDIR}"/${PN}.svg
		make_desktop_entry ${PN} "UrbanTerror"
	fi

	if use dedicated || use server ; then
		newgamesbin build/$(usex debug "debug" "release")-linux-${my_arch}/Quake3-UrT-Ded.${my_arch} ${PN}-dedicated
		docinto examples
		dodoc "${S_DATA}"/q3ut4/{server_example.cfg,mapcycle_example.txt}
	fi

	prepgamesdirs

	if use pax_kernel; then
		pax-mark m "${D}""${GAMES_BINDIR}"/${PN} || die
	fi

}

pkg_preinst() {
	games_pkg_preinst
	use dedicated || gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	use dedicated || gnome2_icon_cache_update

	if use openal && ! use dedicated ; then
		einfo
		elog "You might need to set:"
		elog "  seta s_useopenal \"1\""
		elog "in your ~/.q3a/q3ut4/q3config.cfg for openal to work."
		einfo
	fi
}

pkg_postrm() {
	use dedicated || gnome2_icon_cache_update
}
