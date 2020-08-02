# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit cmake python-single-r1 xdg

DESCRIPTION="Atari ST emulator"
HOMEPAGE="https://hatari.tuxfamily.org/"
SRC_URI="https://download.tuxfamily.org/hatari/${PV}/${P}.tar.bz2"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="capsimage microphone png portmidi readline +sdl2 udev zlib"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	capsimage? ( >=dev-libs/spsdeclib-5.1-r1 )
	microphone? ( media-libs/portaudio )
	png? ( media-libs/libpng:0= )
	portmidi? ( media-libs/portmidi )
	readline? ( sys-libs/readline:0= )
	sdl2? ( media-libs/libsdl2[sound,video,X] )
	!sdl2? ( media-libs/libsdl[sound,video,X] )
	udev? ( virtual/udev )
	zlib? ( sys-libs/zlib )
"

RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')
	>=games-emulation/emutos-0.9.9.1
"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-default-rom.patch
	"${FILESDIR}"/${PN}-2.2.1-joystick.patch
)

DOCS=(
	readme.txt
	doc/{changelog,coding,scsi-driver,thanks,video-recording}.txt
)

src_prepare() {
	xdg_environment_reset
	cmake_src_prepare

	sed -i "s/\.1\.gz\b/.1/g;T;s/gzip[^\$]*/cat /g" {*/,}*/CMakeLists.txt || die
	sed -i "s:\"doc\" + sep + \"hatari\":\"doc/${PF}\":" python-ui/uihelpers.py || die
	sed -i "s/python/${EPYTHON}/" tools/atari-hd-image.sh || die

	# Use emutos package rather than bundled ROM.
	rm src/tos.img || die
}

src_configure() {
	mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DDOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		-DENABLE_SDL2=$(usex sdl2)
		-DCMAKE_DISABLE_FIND_PACKAGE_CapsImage=$(usex !capsimage)
		-DCMAKE_DISABLE_FIND_PACKAGE_PortAudio=$(usex !microphone)
		-DCMAKE_DISABLE_FIND_PACKAGE_PortMidi=$(usex !portmidi)
		-DCMAKE_DISABLE_FIND_PACKAGE_PNG=$(usex !png)
		-DCMAKE_DISABLE_FIND_PACKAGE_Readline=$(usex !readline)
		-DCMAKE_DISABLE_FIND_PACKAGE_Udev=$(usex !udev)
		-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=$(usex !zlib)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_fix_shebang "${ED}"/usr/share/${PN}/
}
