# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop check-reqs toolchain-funcs

MY_PN="${PN^}"
DESCRIPTION="Fork of Nexuiz, Deathmatch FPS based on DarkPlaces, an advanced Quake 1 engine"
HOMEPAGE="https://www.xonotic.org/"
SRC_URI="https://dl.xonotic.org/${P}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	sdl? ( media-libs/libsdl2[X,sound,joystick,opengl,video,alsa?] )"
UIDEPEND="
	x11-base/xorg-proto"
RDEPEND="
	sys-libs/zlib
	virtual/jpeg:0
	media-libs/libpng:0
	net-misc/curl
	~dev-libs/d0_blind_id-1.0
	!dedicated? ( ${UIRDEPEND} )"
DEPEND="${RDEPEND}
	!dedicated? ( ${UIDEPEND} )"
BDEPEND="app-arch/unzip"

DOCS="Docs/*.txt"

CHECKREQS_DISK_BUILD="1200M"
CHECKREQS_DISK_USR="950M"

S="${WORKDIR}/${MY_PN}"

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
}

src_prepare() {
	default

	sed -i \
		-e "/^EXE_/s|darkplaces|${PN}|" \
		-e "s|-O3|${CFLAGS}|" \
		-e "/-lm/s|$| ${LDFLAGS}|" \
		-e '/^STRIP/s|strip|true|' \
		source/darkplaces/makefile.inc || die

	if ! use alsa; then
		sed -i \
			-e "/DEFAULT_SNDAPI/s|ALSA|OSS|" \
			source/darkplaces/makefile || die
	fi
}

src_compile() {
	local t="$(usex debug debug release)"
	local i

	tc-export CC CXX LD AR RANLIB

	# use a for-loop wrt bug 473352
	for i in sv-${t} $(usex !dedicated "cl-${t} $(usex sdl "sdl-${t}" "")" "") ; do
		emake \
			-C source/darkplaces \
			DP_LINK_ODE=$(usex ode shared no) \
			DP_FS_BASEDIR="/usr/share/${PN}" \
			${i}
	done
}

src_install() {
	if ! use dedicated; then
		dobin source/darkplaces/${PN}-glx
		newicon misc/logos/${PN}_icon.svg ${PN}.svg
		make_desktop_entry ${PN}-glx "${MY_PN} (GLX)"

		if use sdl; then
			dobin source/darkplaces/${PN}-sdl
			make_desktop_entry ${PN}-sdl "${MY_PN} (SDL)"
		fi
	fi
	dobin source/darkplaces/${PN}-dedicated

	use doc && local HTML_DOCS=( Docs/htmlfiles Docs/faq.html )
	einstalldocs

	insinto "/usr/share/${PN}"
	doins -r key_0.d0pk server data
}
