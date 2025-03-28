# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="A Python module to make simple GUIs with Rofi (fork for Papis)"
HOMEPAGE="
	https://pypi.org/project/papis-python-rofi/
	https://github.com/papis/python-rofi
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
