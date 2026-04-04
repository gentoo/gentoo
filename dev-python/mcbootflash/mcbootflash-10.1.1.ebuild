# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_VERIFY_REPO=https://github.com/bessman/mcbootflash
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Flash firmware to devices running Microchip's 16-bit bootloader"
HOMEPAGE="
	https://pypi.org/project/mcbootflash/
	https://github.com/bessman/mcbootflash/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/bincopy-20.0.0[${PYTHON_USEDEP}]
	dev-python/datastructclass[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-reserial )
distutils_enable_tests pytest
