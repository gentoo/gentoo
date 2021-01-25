# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 virtualx

DESCRIPTION="Python screenshot library"
HOMEPAGE="https://github.com/ponty/pyscreenshot"
SRC_URI="https://github.com/ponty/pyscreenshot/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? (
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
	media-gfx/imagemagick
	media-gfx/pqiv
	kde-apps/gwenview
	x11-apps/xdpyinfo
)"

DEPEND="
	dev-python/easyprocess[${PYTHON_USEDEP}]
	dev-python/entrypoint2[${PYTHON_USEDEP}]
	dev-python/jeepney[${PYTHON_USEDEP}]
	dev-python/mss[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# Needs access to dbus
	sed -i -e 's:test_kwin_dbus:_&:' \
			tests/test_kwin_dbus.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	virtx pytest -vv
}
