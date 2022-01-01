# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 virtualx

DESCRIPTION="Python screenshot library"
HOMEPAGE="https://github.com/ponty/pyscreenshot"
SRC_URI="https://github.com/ponty/pyscreenshot/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/easyprocess[${PYTHON_USEDEP}]
	dev-python/entrypoint2[${PYTHON_USEDEP}]
	dev-python/jeepney[${PYTHON_USEDEP}]
	dev-python/mss[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/python-xlib[${PYTHON_USEDEP}]
		dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
		media-gfx/imagemagick
		media-gfx/pqiv
		x11-apps/xdpyinfo
	)
"

distutils_enable_tests pytest

python_test() {
	# skip GNOME/KDE tests that require D-BUS
	local -x XDG_CURRENT_DESKTOP=none
	virtx epytest --deselect tests/test_check.py::test_speedtest
}
