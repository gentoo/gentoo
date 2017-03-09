# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit check-reqs eutils gnome2-utils pax-utils

ENGINE_PV=${PV}

MY_PN=UrbanTerror
MY_PV=43_full

DESCRIPTION="Hollywood tactical shooter based on the ioquake3 engine"
HOMEPAGE="http://www.urbanterror.info/home/"
SRC_URI="https://up.barbatos.fr/urt/${MY_PN}${MY_PV}.zip
	https://github.com/Barbatos/ioq3-for-UrbanTerror-4/archive/release-${ENGINE_PV}.tar.gz -> ${PN}-${ENGINE_PV}.tar.gz
	https://upload.wikimedia.org/wikipedia/commons/5/56/Urbanterror.svg -> ${PN}.svg"

# fetch updates
if [[ "${PV}" != "4.3.0" ]]; then
	MY_CTR=0
	while [[ "${MY_CTR}" -lt "${PV/4.3./}" ]]; do
		SRC_URI="${SRC_URI} https://up.barbatos.fr/urt/${MY_PN}-4.3.${MY_CTR}-to-4.3.$(( ${MY_CTR} + 1 )).zip"
		MY_CTR=$(( ${MY_CTR} + 1 ))
	done
fi
unset MY_CTR

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
S_DATA=${WORKDIR}/UrbanTerror43

CHECKREQS_DISK_BUILD="3300M"
CHECKREQS_DISK_USR="1550M"

pkg_pretend() {
	if ! use dedicated ; then
		if ! use sdl && ! use openal ; then
			ewarn
			ewarn "Sound support disabled. Enable 'sdl' or 'openal' useflag."
			ewarn
		fi
	fi
}

src_unpack() {
	local MY_CTR
	default
	# apply updates we fetched before
	if [[ "${PV}" != "4.3.0" ]]; then
		MY_CTR=0
		while [[ "${MY_CTR}" -lt "${PV/4.3./}" ]]; do
			cp -dfpr \
				"${WORKDIR}"/${MY_PN}-4.3.${MY_CTR}-to-4.3.$(( ${MY_CTR} + 1 ))/* \
				"${S_DATA}"
			MY_CTR=$(( ${MY_CTR} + 1 ))
		done
	fi
}
src_prepare() {
	eapply "${FILESDIR}"/${P}-{build,nocurl}.patch
	eapply_user
}

src_compile() {
	buildit() { use $1 && echo 1 || echo 0 ; }
	nobuildit() { use $1 && echo 0 || echo 1 ; }

	emake \
		ARCH=$(usex amd64 "x86_64" "i386") \
		DEFAULT_BASEDIR="${ED}/usr/share/${PN}" \
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
	# docs from ioq3 by barbatos via github
	dodoc "${S}"/ChangeLog README md4-readme.txt
	# docs from urbanterror by frozensand
	dodoc "${S_DATA}"/q3ut4/readme43.txt

	insinto /usr/share/${PN}/q3ut4
	doins "${S_DATA}"/q3ut4/*.pk3

	if use !dedicated ; then
		newbin build/$(usex debug "debug" "release")-linux-${my_arch}/Quake3-UrT$(usex smp "-smp" "").${my_arch} ${PN}
		doicon -s scalable "${DISTDIR}"/${PN}.svg
		make_desktop_entry ${PN} "UrbanTerror"
	fi

	if use dedicated || use server ; then
		newbin build/$(usex debug "debug" "release")-linux-${my_arch}/Quake3-UrT-Ded.${my_arch} ${PN}-dedicated
		docinto examples
		dodoc "${S_DATA}"/q3ut4/{server_example.cfg,mapcycle_example.txt}
	fi

	if use pax_kernel; then
		pax-mark m "${D}""${GAMES_BINDIR}"/${PN} || die
	fi

}

pkg_preinst() {
	use dedicated || gnome2_icon_savelist
}

pkg_postinst() {
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
