# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pytest plugin for recording and replaying serial port traffic during tests"
HOMEPAGE="
	https://pypi.org/project/pytest-reserial/
	https://github.com/bessman/pytest-reserial/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
