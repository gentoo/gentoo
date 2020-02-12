# Copyright 2016-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Multi-vendor library to simplify Paramiko SSH connections to network devices"
HOMEPAGE="https://github.com/ktbyers/netmiko"
LICENSE="MIT"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/scp[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
