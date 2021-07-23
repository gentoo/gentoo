# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Command line VNC client"
HOMEPAGE="https://github.com/sibson/vncdotool"
SRC_URI="https://github.com/sibson/vncdotool/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

# No clue why this happens:
# pexpect.exceptions.ExceptionPexpect: The command was not found or was not executable: vncev.
RESTRICT="test"

BDEPEND="test? (
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/ptyprocess[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/tox[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
)"

DEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs
