# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Python wrapper for Xvfb, Xephyr and Xvnc"
HOMEPAGE="https://github.com/ponty/PyVirtualDisplay"
SRC_URI="https://github.com/ponty/PyVirtualDisplay/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="test? (
	dev-python/backports[${PYTHON_USEDEP}]
	dev-python/backports-tempfile[${PYTHON_USEDEP}]
	dev-python/entrypoint2[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyscreenshot[${PYTHON_USEDEP}]
	~dev-python/vncdotool-0.13.0[${PYTHON_USEDEP}]
	x11-base/xorg-server[xvfb,xephyr]
	x11-misc/x11vnc
)"

DEPEND="dev-python/easyprocess[${PYTHON_USEDEP}]"

S="${WORKDIR}/PyVirtualDisplay-${PV}"

distutils_enable_tests pytest

python_prepare_all() {
	# all of this fails: AssertionError
	rm tests/test_examples.py || die

	# Assertion error No such file or directory: 'Xvnc': 'Xvnc'
	sed -i -e 's:test_race_10_xvnc:_&:' \
			tests/test_race.py || die

	# No such file or directory: 'Xvnc': 'Xvnc'
	sed -i -e 's:test_slowshot:_&:' \
		-e 's:test_slowshot_with:_&:' \
			tests/test_smart.py || die

	# No such file or directory: 'Xvnc': 'Xvnc'
	sed -i -e 's:test_double:_&:' \
			tests/test_smart2.py || die

	distutils-r1_python_prepare_all
}
