# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

MY_P=PyVirtualDisplay-${PV}
DESCRIPTION="Python wrapper for Xvfb, Xephyr and Xvnc"
HOMEPAGE="https://github.com/ponty/PyVirtualDisplay"
SRC_URI="
	https://github.com/ponty/PyVirtualDisplay/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/easyprocess[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/backports-tempfile[${PYTHON_USEDEP}]
		dev-python/entrypoint2[${PYTHON_USEDEP}]
		dev-python/path-py[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyscreenshot[${PYTHON_USEDEP}]
		~dev-python/vncdotool-0.13.0[${PYTHON_USEDEP}]
		x11-apps/xmessage
		x11-base/xorg-server[xvfb,xephyr]
		x11-misc/x11vnc
	)"

distutils_enable_tests pytest
