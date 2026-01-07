# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Run system terminals inside Spyder"
HOMEPAGE="https://github.com/spyder-ide/spyder-terminal"

LICENSE="MIT BSD Apache-2.0 BSD-2 ISC CC-BY-4.0 ZLIB WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/coloredlogs[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/spyder-6.1.0[${PYTHON_USEDEP}]
	<dev-python/spyder-7[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.13.1[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
"
