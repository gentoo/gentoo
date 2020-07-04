# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 xdg-utils

DESCRIPTION="A frontend for Mupen64Plus"
HOMEPAGE="http://m64py.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/m64py/${P}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 public-domain GPL-2 BSD CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="7z rar"

RDEPEND="
	dev-python/PyQt5[gui,opengl,widgets,${PYTHON_USEDEP}]
	dev-python/PySDL2[${PYTHON_USEDEP}]
	media-libs/libsdl2[joystick,video]
	>=games-emulation/mupen64plus-core-2.5:0/2-sdl2
	7z? (
		|| (
			dev-python/pylzma[${PYTHON_USEDEP}]
			app-arch/p7zip
		)
	)
	rar? (
		|| (
			dev-python/rarfile[${PYTHON_USEDEP}]
			app-arch/unrar
			app-arch/rar
		)
	)"

python_prepare_all() {
	# set the correct search path
	cat >> src/m64py/platform.py <<-_EOF_ || die
		SEARCH_DIRS = ["/usr/$(get_libdir)/mupen64plus"]
	_EOF_

	distutils-r1_python_prepare_all
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
