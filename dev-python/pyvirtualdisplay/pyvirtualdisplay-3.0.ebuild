# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=PyVirtualDisplay-${PV}
DESCRIPTION="Python wrapper for Xvfb, Xephyr and Xvnc"
HOMEPAGE="
	https://github.com/ponty/PyVirtualDisplay/
	https://pypi.org/project/PyVirtualDisplay/
"
SRC_URI="
	https://github.com/ponty/PyVirtualDisplay/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

BDEPEND="
	test? (
		dev-python/easyprocess[${PYTHON_USEDEP}]
		dev-python/entrypoint2[${PYTHON_USEDEP}]
		dev-python/path[${PYTHON_USEDEP}]
		dev-python/pillow[xcb,${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyscreenshot[${PYTHON_USEDEP}]
		x11-apps/xmessage
		x11-base/xorg-server[xvfb,xephyr]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# require old vncdotool
	tests/test_xvnc.py
)
