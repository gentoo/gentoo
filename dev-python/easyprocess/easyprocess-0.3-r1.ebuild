# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Easy to use Python subprocess interface"
HOMEPAGE="https://github.com/ponty/EasyProcess"
SRC_URI="https://github.com/ponty/EasyProcess/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="test? (
	dev-python/pytest-timeout[${PYTHON_USEDEP}]
	dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	x11-base/xorg-server[xvfb]
)"

S="${WORKDIR}/EasyProcess-${PV}"

distutils_enable_tests pytest
