# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Zabbix module for Python"
HOMEPAGE="https://pypi.org/project/py-zabbix https://github.com/adubkov/py-zabbix"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
