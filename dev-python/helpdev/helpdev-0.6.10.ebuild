# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Helping users and developers to get information about the environment"
HOMEPAGE="https://gitlab.com/dpizetta/helpdev"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]"
