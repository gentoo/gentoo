# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit cmake-utils python-single-r1 readme.gentoo-r1

DESCRIPTION="Atari ST emulator"
HOMEPAGE="http://hatari.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/hatari/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sdl2"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/spsdeclib-5.1-r1
	sdl2? ( media-libs/libsdl2[X,sound,video] )
	!sdl2? ( media-libs/libsdl[X,sound,video] )
	media-libs/portaudio
	media-libs/portmidi
	sys-libs/readline:0=
	media-libs/libpng:0=
	sys-libs/zlib:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="dev-python/pygtk[${PYTHON_USEDEP}]
	>=games-emulation/emutos-0.9.9.1"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
You need a TOS ROM to run hatari. EmuTOS, a free TOS implementation,
has been installed in /usr/lib*/hatari with a .img extension (there
are several from which to choose).
Another option is to go to http://www.atari.st/ and get a real TOS:
http://www.atari.st/
The first time you run hatari, you should configure it to find the
TOS you prefer to use.  Be sure to save your settings.
"

PATCHES=( "${FILESDIR}/${P}_caps5_files.patch" )
DOCS="readme.txt doc/*.txt"
HTML_DOCS="doc/"

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e '/Encoding/d' ./python-ui/hatariui.desktop || die
	sed -i -e "s/python/${EPYTHON}/" tools/atari-hd-image.sh || die
	sed -i -e "s#@DOCDIR@#/usr/share/doc/${PF}/html/#" python-ui/uihelpers.py || die
}

src_configure() {
	mycmakeargs=(
		"-DDOCDIR=/usr/share/doc/${PF}"
		"-DENABLE_SDL2=$(usex sdl2)"
		"-DENABLE_CAPSIMAGE5=ON"
		)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED%/}"/usr/share/hatari/{hatariui,hconsole}/
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
