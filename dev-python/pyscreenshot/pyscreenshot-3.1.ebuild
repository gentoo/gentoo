# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 virtualx

DESCRIPTION="Python screenshot library"
HOMEPAGE="
	https://github.com/ponty/pyscreenshot/
	https://pypi.org/project/pyscreenshot/
"
SRC_URI="
	https://github.com/ponty/pyscreenshot/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	dev-python/easyprocess[${PYTHON_USEDEP}]
	dev-python/entrypoint2[${PYTHON_USEDEP}]
	dev-python/jeepney[${PYTHON_USEDEP}]
	dev-python/mss[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pillow[xcb,${PYTHON_USEDEP}]
		dev-python/pygame[${PYTHON_USEDEP}]
		dev-python/python-xlib[${PYTHON_USEDEP}]
		dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
		media-gfx/imagemagick
		media-gfx/pqiv
		media-gfx/scrot
		x11-apps/xdpyinfo
	)
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		tests/test_check.py::test_speedtest
	)

	# skip GNOME/KDE tests that require D-BUS
	local -x XDG_CURRENT_DESKTOP=none
	# nonfatal is already implied by virtx, make it explicit though
	nonfatal epytest || die "Tests failed with ${EPYTHON}"
}
