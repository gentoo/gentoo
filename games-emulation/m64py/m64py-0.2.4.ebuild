# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1 xdg-utils

DESCRIPTION="A frontend for Mupen64Plus"
HOMEPAGE="http://m64py.sourceforge.net/"
SRC_URI="mirror://sourceforge/m64py/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 public-domain GPL-2 BSD CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/PyQt5[gui,opengl,widgets,${PYTHON_USEDEP}]
	dev-python/PySDL2[${PYTHON_USEDEP}]
	media-libs/libsdl2[joystick,video]
	>=games-emulation/mupen64plus-core-2.5:0/2-sdl2"

python_prepare_all() {
	# set the correct search path
	cat >> src/m64py/platform.py <<-_EOF_
		SEARCH_DIRS = ["/usr/$(get_libdir)/mupen64plus"]
_EOF_

	distutils-r1_python_prepare_all
}

pkg_postinst() {
	xdg_desktop_database_update

	if ! type -P rar >/dev/null && ! type -P unrar >/dev/null; then
		elog
		elog "In order to gain RAR archive support, please install either app-arch/rar"
		elog "or app-arch/unrar."
	fi

	if ! type -P 7z >/dev/null \
			&& ! has_version "dev-python/pylzma[${PYTHON_USEDEP}]"; then
		elog
		elog "In order to gain 7z archive support, please install either app-arch/p7zip"
		elog "or dev-python/pylzma."
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
