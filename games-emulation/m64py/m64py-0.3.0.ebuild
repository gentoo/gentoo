# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 qmake-utils xdg-utils

MY_P=mupen64plus-ui-python-${PV}
DESCRIPTION="A frontend for Mupen64Plus"
HOMEPAGE="
	https://m64py.sourceforge.net/
	https://github.com/mupen64plus/mupen64plus-ui-python/
"
SRC_URI="
	https://github.com/mupen64plus/mupen64plus-ui-python/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3 LGPL-3 public-domain GPL-2 BSD CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="7z rar"

RDEPEND="
	dev-python/pyqt6[gui,opengl,widgets,${PYTHON_USEDEP}]
	dev-python/pysdl2[${PYTHON_USEDEP}]
	media-libs/libsdl2[joystick,video]
	>=games-emulation/mupen64plus-core-2.5:0/2-sdl2
	7z? (
		app-arch/p7zip
	)
	rar? (
		|| (
			dev-python/rarfile[${PYTHON_USEDEP}]
			app-arch/unrar
			app-arch/rar
		)
	)
"
BDEPEND="
	dev-qt/qttools:6
"

python_prepare_all() {
	# set the correct search path
	cat >> src/m64py/platform.py <<-_EOF_ || die
		SEARCH_DIRS = ["/usr/$(get_libdir)/mupen64plus"]
	_EOF_

	distutils-r1_python_prepare_all
}

python_compile() {
	local -x PATH=$(qt6_get_bindir):${PATH}
	distutils-r1_python_compile
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
