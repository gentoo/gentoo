# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper xdg

DESCRIPTION="Atmospheric side-scrolling action adventure platformer set in a gorgeous forest"
HOMEPAGE="http://badlandgame.com"
SRC_URI="
	Badland_GotY_${PV}.tar
	https://dev.gentoo.org/~chewi/distfiles/${PN}.png"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch mirror splitdebug"

QA_PREBUILT="opt/${PN}/*"

BDEPEND="app-admin/chrpath"
RDEPEND="
	dev-db/sqlite:3[abi_x86_32]
	media-libs/fontconfig:1.0[abi_x86_32]
	media-libs/freetype:2[abi_x86_32]
	media-libs/libpng-compat:1.2[abi_x86_32]
	media-libs/libsdl2[abi_x86_32,joystick,opengl,sound,threads,video]
	net-misc/curl[abi_x86_32]
	>=sys-devel/gcc-4.6[cxx]
	>=sys-libs/glibc-2.14
	virtual/opengl[abi_x86_32]
	x11-libs/libX11[abi_x86_32]
"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/badland-game-of-the-year-humble-deluxe-edition"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default

	# Replace insecure RPATH.
	chrpath -r '$ORIGIN' ${PN} || die
}

src_install() {
	local dir=/opt/${PN}

	insinto "${dir}"
	doins -r Resources

	exeinto "${dir}"
	doexe ${PN} *.so

	make_wrapper ${PN} "./${PN}" "${dir}"
	make_desktop_entry ${PN} "Badland"

	doicon -s 128 "${DISTDIR}"/${PN}.png
}
