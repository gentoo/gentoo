# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Open-world sandbox game set in an infinite abstract universe"
HOMEPAGE="http://murudai.com/solar/"
SRC_URI="
	${PN}-linux-${PV}.tar.gz
	fetch+https://dev.gentoo.org/~chewi/distfiles/${PN}.png"
S="${WORKDIR}/Solar2"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

# game outputs audio using openal and libsdl backends simultaneously
RDEPEND="
	media-libs/libsdl[X,joystick,opengl,sound,video,abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	media-libs/sdl-mixer[mad,mp3,abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

QA_PREBUILT="
	opt/${PN}/Solar2.bin.x86
	opt/${PN}/lib/libmono-2.0.so.1"

pkg_nofetch() {
	einfo "Please buy and download '${A%% *}' from:"
	einfo "  ${HOMEPAGE}"
	einfo "and place it in your distfiles directory. The Humble Bundle"
	einfo "download may have a timestamp appended to the filename."
}

src_prepare() {
	default

	# remove duplicate libmono and unused wrapper
	rm lib/libmono-2.0.so solar2.sh || die

	# remove bundled libs except mono (had no success using system's)
	rm lib/lib{SDL_mixer-1.2,mad,mikmod,openal}.so* || die
}

src_install() {
	insinto /opt/${PN}
	doins -r .

	fperms +x /opt/${PN}/Solar2.bin.x86
	make_wrapper ${PN} ./Solar2.bin.x86 /opt/${PN}

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Solar 2"

	# game insists on loading sdl-mixer from its own directory
	dosym -r /{usr,opt/${PN}}/lib/libSDL_mixer-1.2.so.0
}
