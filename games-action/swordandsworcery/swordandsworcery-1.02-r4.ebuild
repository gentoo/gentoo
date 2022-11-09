# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="An exploratory action adventure game with an emphasis on audiovisual style"
HOMEPAGE="http://www.swordandsworcery.com/"
SRC_URI="${PN}_${PV}.tar.gz"
S="${WORKDIR}"

LICENSE="CAPYBARA-EULA LGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=/opt/${PN}
QA_PREBUILT="
	${MYGAMEDIR#/}/bin/*
	${MYGAMEDIR#/}/lib/*
"

# TODO: unbundle liblua-5.1 when available for multilib
# linked to pulseaudio
RDEPEND="
	virtual/opengl
	amd64? (
		>=dev-libs/openssl-1.0.1h-r2:0=[abi_x86_32(-)]
		>=sys-libs/zlib-1.2.8-r1[abi_x86_32(-)]
		>=virtual/glu-9.0-r1[abi_x86_32(-)]
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)]
		|| ( media-libs/flac:0/0[abi_x86_32(-)] media-libs/flac-compat:8.3.0[abi_x86_32(-)] )
		>=media-libs/libogg-1.3.0[abi_x86_32(-)]
		>=media-libs/libsndfile-1.0.25[abi_x86_32(-)]
		>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
		>=media-sound/pulseaudio-2.1-r1[abi_x86_32(-)]
		>=x11-libs/libICE-1.0.8-r1[abi_x86_32(-)]
		>=x11-libs/libSM-1.2.1-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXau-1.0.7-r1[abi_x86_32(-)]
		>=x11-libs/libxcb-1.9.1[abi_x86_32(-)]
		>=x11-libs/libXdmcp-1.1.1-r1[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=x11-libs/libXi-1.7.2[abi_x86_32(-)]
		>=x11-libs/libXtst-1.2.1-r1[abi_x86_32(-)]
		!bundled-libs? (
			>=net-misc/curl-7.36.0[abi_x86_32(-)]
			>=media-libs/libsdl-1.2.15-r4[X,sound,video,opengl,joystick,abi_x86_32(-)]
		)
	)
	x86? (
		dev-libs/openssl:0=
		media-libs/alsa-lib
		|| ( media-libs/flac:0/0 media-libs/flac-compat:8.3.0 )
		media-libs/libogg
		media-libs/libsndfile
		media-libs/libvorbis
		media-sound/pulseaudio
		sys-libs/zlib
		virtual/glu
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXtst
		!bundled-libs? (
			net-misc/curl
			media-libs/libsdl[X,sound,video,opengl,joystick]
		)
	)"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
}

src_prepare() {
	default

	if ! use bundled-libs ; then
		einfo "removing bundled libs..."
		rm -v lib/libcurl.so* lib/libSDL-1.2.so* \
			lib/libstdc++.so* || die
	fi

	sed \
		-e "s#@GAMEDIR@#${MYGAMEDIR}#" \
		"${FILESDIR}"/${PN}-wrapper > "${T}"/${PN} || die
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins -r bin lib res

	dobin "${T}"/${PN}
	make_desktop_entry ${PN}

	docinto html
	dodoc README.html

	fperms +x "${MYGAMEDIR}"/bin/${PN}
}
