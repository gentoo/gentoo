# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="pytest plugin for adding to the PYTHONPATH from command line or configs"
HOMEPAGE="https://pypi.python.org/pypi/pytest-pythonpath https://github.com/bigsassy/pytest-pythonpath"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
