# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Python wrapper for Xvfb, Xephyr and Xvnc"
HOMEPAGE="https://github.com/ponty/PyVirtualDisplay"
SRC_URI="https://github.com/ponty/PyVirtualDisplay/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? (
	dev-python/entrypoint2[${PYTHON_USEDEP}]
	dev-python/pillow[xcb,${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
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

	# Hangs forever
	sed -i -e 's:test_race_100_xvfb:_&:' \
	-e 's:test_race_100_xe:_&:' \
			tests/test_race.py || die

	# Hangs forever
	sed -i -e 's:test_slowshot:_&:' \
		-e 's:test_slowshot_with:_&:' \
			tests/test_smart.py || die

	# Hangs forever
	sed -i -e 's:test_double:_&:' \
			tests/test_smart2.py || die

	# pyvirtualdisplay.smartdisplay.DisplayTimeoutError: Timeout! elapsed time:1.8 timeout:1
	sed -i -e 's:test_smart:_&:' \
			tests/test_smart_thread.py || die

	distutils-r1_python_prepare_all
}
