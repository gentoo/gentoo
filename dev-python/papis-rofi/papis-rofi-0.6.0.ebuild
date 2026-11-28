# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="Rofi based papis interface"
HOMEPAGE="
	https://pypi.org/project/papis-rofi
	https://github.com/papis/papis-rofi
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/papis-python-rofi-1.0.3[${PYTHON_USEDEP}]
"
