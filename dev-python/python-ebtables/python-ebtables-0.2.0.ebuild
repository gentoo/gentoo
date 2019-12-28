# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="Python bindings for ebtables"
HOMEPAGE="https://github.com/ldx/python-iptables"
SRC_URI="https://github.com/ldx/${PN}/archive/v0.2.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-firewall/ebtables[-static]
	dev-python/cffi[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
