# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Zabbix module for Python"
HOMEPAGE="https://pypi.org/project/py-zabbix https://github.com/adubkov/py-zabbix"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
