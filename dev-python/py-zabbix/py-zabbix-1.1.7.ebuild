# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..10} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Zabbix module for Python"
HOMEPAGE="https://pypi.org/project/py-zabbix https://github.com/adubkov/py-zabbix"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
