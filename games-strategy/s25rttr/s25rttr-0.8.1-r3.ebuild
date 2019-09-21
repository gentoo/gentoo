# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop gnome2-utils readme.gentoo-r1

DESCRIPTION="Open Source remake of The Settlers II game (needs original game files)"
HOMEPAGE="https://www.siedler25.org/"
# no upstream source tarball yet
# https://bugs.launchpad.net/s25rttr/+bug/1069546
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	app-arch/bzip2
	media-libs/libsamplerate
	media-libs/libsdl[X,sound,opengl,video]
	media-libs/libsndfile
	media-libs/sdl-mixer[vorbis]
	net-libs/miniupnpc
	virtual/libiconv
	virtual/opengl
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

DOCS=( RTTR/texte/{keyboardlayout.txt,readme.txt} )

DOC_CONTENTS="Copy your Settlers2 game files into ~/.${PN}/S2"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-soundconverter.patch
	"${FILESDIR}"/${P}-fpic.patch
	"${FILESDIR}"/${P}-format.patch
	"${FILESDIR}"/${P}-miniupnpc-api-14.patch
	"${FILESDIR}"/${P}-cmake-3.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_configure() {
	local mycmakeargs=(
		-DCOMPILEFOR="linux"
		-DCMAKE_SKIP_RPATH=YES
		-DPREFIX="/usr/"
		-DBINDIR="/usr/bin"
		-DDATADIR="/usr/share"
		-DLIBDIR="/usr/$(get_libdir)/${PN}"
		-DDRIVERDIR="/usr/$(get_libdir)/${PN}"
		-DGAMEDIR="~/.${PN}/S2"
		-DBUILD_GLFW_DRIVER=OFF
	)

	cmake-utils_src_configure
}

src_compile() {
	# work around some relative paths (CMAKE_IN_SOURCE_BUILD not supported)
	ln -s "${CMAKE_USE_DIR}"/RTTR "${CMAKE_BUILD_DIR}"/RTTR || die

	cmake-utils_src_compile

	mv "${CMAKE_USE_DIR}"/RTTR/{sound-convert,s-c_resample} "${T}"/ || die
}

src_install() {
	cd "${CMAKE_BUILD_DIR}" || die

	exeinto /usr/"$(get_libdir)"/${PN}
	doexe "${T}"/{sound-convert,s-c_resample}
	exeinto /usr/"$(get_libdir)"/${PN}/video
	doexe driver/video/SDL/src/libvideoSDL.so
	exeinto /usr/"$(get_libdir)"/${PN}/audio
	doexe driver/audio/SDL/src/libaudioSDL.so

	insinto /usr/share
	doins -r "${CMAKE_USE_DIR}"/RTTR
	dosym ./LSTS/splash.bmp /usr/share/RTTR/splash.bmp

	doicon -s 64 "${CMAKE_USE_DIR}"/debian/${PN}.png
	dobin src/s25client
	make_desktop_entry "s25client" "Settlers RTTR" "${PN}"

	einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_icon_cache_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_icon_cache_update
}
