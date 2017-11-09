# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit flag-o-matic gnome2-utils

DESCRIPTION="Hollywood tactical shooter based on the ioquake3 engine"
HOMEPAGE="http://urbanterror.info https://github.com/mickael9/ioq3"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mickael9/ioq3.git"
	EGIT_BRANCH="urt"
else
	COMMIT_ID="3e555ab1405c38556cbfcdd42eac23a4af49e633"
	SRC_URI="https://github.com/mickael9/ioq3/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ioq3-${COMMIT_ID}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+altgamma +client +curl debug mumble openal +opus server voip vorbis"
REQUIRED_USE=" || ( client server )"

PATCHES=( "${FILESDIR}"/${PN}-4.3-respect_CFLAGS.patch )

RDEPEND="
	client? (
		media-libs/libsdl2[X,sound,joystick,opengl,video]
		mumble? ( media-sound/mumble )
		openal? ( media-libs/openal )
		opus? ( media-libs/opusfile )
		vorbis? (
			media-libs/libogg
			media-libs/libvorbis
		)
	)
	curl? ( net-misc/curl )
	~games-fps/urbanterror-data-4.3.2
	sys-libs/zlib[minizip]
	virtual/jpeg:0
"

DEPEND="${RDEPEND}"

pkg_pretend() {
	if use client; then
		if ! use openal && ! use opus && ! use vorbis; then
			ewarn
			ewarn "No sound implementation selected. Enable 'openal', 'opus' or 'vorbis' USE flag to get sound!"
		fi
	fi
}

src_compile() {
	# Workaround for used zlib macro, wrt bug #449510
	append-flags "-DOF=_Z_OF"
	local my_arch=$(usex amd64 "x86_64" "i386")

	emake \
		ARCH=${my_arch} \
		DEFAULT_BASEDIR="/usr/share/urbanterror" \
		BUILD_CLIENT=$(usex "client" 1 0) \
		BUILD_SERVER=$(usex "server" 1 0) \
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
		USE_OPENAL=$(usex "openal" 1 0) \
		USE_OPENAL_DLOPEN=$(usex "openal" 1 0) \
		USE_CURL=$(usex "curl" 1 0) \
		USE_CURL_DLOPEN=$(usex "curl" 1 0) \
		USE_CODEC_VORBIS=$(usex "vorbis" 1 0) \
		USE_CODEC_OPUS=$(usex "opus" 1 0) \
		USE_MUMBLE=$(usex "mumble" 1 0) \
		USE_VOIP=$(usex "mumble" 1 0) \
		USE_INTERNAL_LIBS=0 \
		USE_LOCAL_HEADERS=0 \
		USE_ALTGAMMA=$(usex "altgamma" 1 0)
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

	if use server && ! use client; then
		# dedicated server only
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
			elog ""
			elog "You might need to set:"
			elog "  seta s_useopenal \"1\""
			elog "in your ~/.q3a/q3ut4/q3config.cfg for openal to work."
		fi

		if use altgamma; then
			elog ""
			elog "You might need to set:"
			elog "  seta r_altgamma \"1\""
			elog "in your ~/.q3a/q3ut4/q3config.cfg for altgamma to work."
		fi

		if ! use altgamma; then
			elog ""
			elog "If you are using a modesetting graphics driver you might"
			elog "consider setting USE=\"altgamma\"."
			elog "For details take a look at:"
			elog "https://bugs.freedesktop.org/show_bug.cgi?id=27222"
		fi
		if ! use client; then
			elog ""
			elog "You disabled client support. You won't be able to connect"
			elog "to any servers and play. If you want to do so, enable"
			elog "USE=\"client\"."
		fi
	fi
}

pkg_postrm() {
	use client && gnome2_icon_cache_update
}
