# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

FILE_STEM="QuDos-${PV}-src"
PK3_FILE="QuDos-${PV}.pk3"
MY_PN="quake2"

DESCRIPTION="Enhanced Quake 2 engine"
HOMEPAGE="https://github.com/ZwS/qudos"
SRC_URI="mirror://gentoo/${FILE_STEM}.tar.bz2
	https://github.com/ZwS/qudos/raw/master/quake2/baseq2/qudos.pk3 -> ${PK3_FILE}"
S="${WORKDIR}"/${FILE_STEM}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall debug dedicated demo dga ipv6 joystick mods opengl qmax oss sdl textures"

DEPEND="
	media-libs/libogg
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/libvorbis
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	opengl? (
		virtual/opengl
		virtual/glu
	)
	sdl? (
		media-libs/libsdl[joystick?,opengl,sound,video]
		virtual/opengl
		virtual/glu
	)
"
RDEPEND="
	${DEPEND}
	cdinstall? ( games-fps/quake2-data )
	demo? ( games-fps/quake2-demodata[symlink] )
	textures? ( games-fps/quake2-textures )
"
BDEPEND="virtual/pkgconfig"

dir=usr/share/${MY_PN}

PATCHES=(
	"${FILESDIR}"/${P}-libpng.patch
	"${FILESDIR}"/${P}-gnusource.patch
	"${FILESDIR}"/${P}-zlib-build.patch
	"${FILESDIR}"/${P}-libjpeg-clash.patch
	"${FILESDIR}"/${P}-respect-libdir.patch
	"${FILESDIR}"/${P}-respect-cc.patch
	"${FILESDIR}"/${P}-use-pkg-config.patch
	"${FILESDIR}"/${P}-no-bits-nan.patch
)

default_client() {
	if use opengl || use sdl || ! use dedicated ; then
		# Build default client
		return 0
	fi
	return 1
}

pkg_setup() {
	if ! use qmax && $( use opengl || use sdl ) ; then
		elog "The 'qmax' graphical improvements are recommended."
		echo
	fi

	if use debug ; then
		ewarn "The 'debug' USE flag may cause compilation to fail with:"
		ewarn
		ewarn "src/qcommon/cmd.c:364: warning: dereferencing type-punned"
		ewarn "pointer will break strict-aliasing rules."
		echo
	fi

	# Determine the default sound driver, in order of preference
	# snd_drv is not a local variable
	snd_drv=""
	[[ -z "${snd_drv}" ]] && use oss && snd_drv="oss"
	[[ -z "${snd_drv}" ]] && use sdl && snd_drv="sdl"
	# Default if nothing else chosen
	[[ -z "${snd_drv}" ]] && snd_drv="oss"

	if default_client ; then
		elog "Selected the ${snd_drv} sound driver as the default."
	fi
}

src_prepare() {
	rm docs/gnu.txt || die

	default

	# Change default sound driver and its location
	sed -i \
		-e "s:\"oss\":\"${snd_drv}\":" \
		-e "s:\"\./snd:\"/usr/$(get_libdir)/${PN}/snd:" \
		src/client/snd_dma.c || die
}

src_configure() {
	append-cflags -fcommon
	default
}

src_compile() {
	yesno() {
		usex ${1} YES NO
	}

	local client="YES"
	default_client || client="NO"

	local type="release"
	use debug && type="debug"

	local myemakeargs=(
		BUILD_QUAKE2="${client}"
		BUILD_DEDICATED=$(yesno dedicated)
		BUILD_GLX=$(yesno opengl)
		BUILD_SDLGL=$(yesno sdl)
		BUILD_ALSA_SND=NO
		BUILD_SDL_SND=$(yesno sdl)
		BUILD_OSS_SND=$(yesno oss)
		WITH_XMMS=NO
		WITH_DGA_MOUSE=$(yesno dga)
		WITH_JOYSTICK=$(yesno joystick)
		TYPE="${type}"
		DATADIR="${dir}"
		LOCALBASE=/usr
		LIBDIR="/usr/$(get_libdir)"/${PN}
		WITH_QMAX=$(yesno qmax)
		BUILD_3ZB2=$(yesno mods)
		BUILD_CTF=$(yesno mods)
		BUILD_JABOT=$(yesno mods)
		BUILD_ROGUE=$(yesno mods)
		BUILD_XATRIX=$(yesno mods)
		BUILD_ZAERO=$(yesno mods)
		WITH_BOTS=$(yesno mods)
		HAVE_IPV6=$(yesno ipv6)
		CC="$(tc-getCC)"
		WITH_X86_ASM=NO
		WITH_DATADIR=YES
		WITH_LIBDIR=YES
		BUILD_DEBUG_DIR=release
		BUILD_RELEASE_DIR=release
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	if default_client ; then
		newbin ${MY_PN}/QuDos ${PN}

		# Change from gif to png in next version?
		newicon docs/q2_orig/quake2.gif ${PN}.gif

		make_desktop_entry ${PN} "QuDos" ${PN}.gif
	fi

	if use dedicated ; then
		newbin ${MY_PN}/QuDos-ded ${PN}-ded
	fi

	insinto "/usr/$(get_libdir)"/${PN}
	doins -r ${MY_PN}/*
	rm "${ED}/usr/$(get_libdir)"/${PN}/QuDos || die

	insinto "/usr/$(get_libdir)"/${PN}/baseq2
	newins "${DISTDIR}/${PK3_FILE}" qudos.pk3

	dodoc $(find docs -name \*.txt) docs/q2_orig/README*
}
