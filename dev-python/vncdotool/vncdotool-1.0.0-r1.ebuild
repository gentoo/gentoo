# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Command line VNC client"
HOMEPAGE="https://github.com/sibson/vncdotool"
SRC_URI="https://github.com/sibson/vncdotool/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

# A lot of errors such as the following appear
# pexpect.exceptions.ExceptionPexpect: The command was not found or was not executable: vncev.
# to install those, a manual compile and install of examples from net-libs/libvncserver is needed
RESTRICT="test"

BDEPEND="test? (
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/ptyprocess[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/tox[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
)"
RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs
