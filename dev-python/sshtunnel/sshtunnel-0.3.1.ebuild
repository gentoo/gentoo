# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Pure Python SSH tunnels"
HOMEPAGE="https://pypi.org/project/sshtunnel/"
SRC_URI="mirror://pypi/s/sshtunnel/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RESTRICT="test"

RDEPEND="dev-python/paramiko[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
