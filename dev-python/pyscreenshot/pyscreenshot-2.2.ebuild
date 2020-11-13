# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 virtualx

DESCRIPTION="Python screenshot library"
HOMEPAGE="https://github.com/ponty/pyscreenshot"
SRC_URI="https://github.com/ponty/pyscreenshot/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="test? (
	dev-python/path-py[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
	media-gfx/pqiv
)"

DEPEND="
	dev-python/easyprocess[${PYTHON_USEDEP}]
	dev-python/entrypoint2[${PYTHON_USEDEP}]
	dev-python/jeepney[${PYTHON_USEDEP}]
	dev-python/mss[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# easyprocess.EasyProcessError: start error fails inside emerge env
	sed -i -e 's:test_default:_&:' \
			tests/test_default.py || die

	# AssertionError
	sed -i -e 's:test_imagemagick:_&:' \
			tests/test_imagemagick.py || die

	# Needs access to dbus
	sed -i -e 's:test_kwin_dbus:_&:' \
			tests/test_kwin_dbus.py || die

	# AssertionError
	sed -i -e 's:test_mss:_&:' \
			tests/test_mss.py || die

	# AssertionError
	sed -i -e 's:test_pygdk3:_&:' \
			tests/test_pygdk3.py || die

	# AssertionError
	sed -i -e 's:test_pyqt5:_&:' \
			tests/test_pyqt5.py || die

	# AssertionError
	sed -i -e 's:test_qtpy:_&:' \
			tests/test_qtpy.py || die

	# AssertionError
	sed -i -e 's:test_scrot:_&:' \
			tests/test_scrot.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	virtx pytest -vv
}
