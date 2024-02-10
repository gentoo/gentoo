# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="SNMP framework in Python - MIBs"
HOMEPAGE="https://github.com/etingof/pysnmp-mibs"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/pysnmp-4.2.3[${PYTHON_USEDEP}]"
