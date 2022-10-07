# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_P=PyVirtualDisplay-${PV}
DESCRIPTION="Python wrapper for Xvfb, Xephyr and Xvnc"
HOMEPAGE="https://github.com/ponty/PyVirtualDisplay"
SRC_URI="
	https://github.com/ponty/PyVirtualDisplay/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/backports-tempfile[${PYTHON_USEDEP}]
		' 3.8)
		dev-python/easyprocess[${PYTHON_USEDEP}]
		dev-python/entrypoint2[${PYTHON_USEDEP}]
		dev-python/path[${PYTHON_USEDEP}]
		dev-python/pillow[xcb,${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyscreenshot[${PYTHON_USEDEP}]
		~dev-python/vncdotool-0.13.0[${PYTHON_USEDEP}]
		x11-apps/xmessage
		x11-base/xorg-server[xvfb,xephyr]
		x11-misc/x11vnc
	)"

distutils_enable_tests pytest
