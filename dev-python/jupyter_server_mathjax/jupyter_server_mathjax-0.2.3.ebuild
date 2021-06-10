# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="MathJax resources as a Jupyter Server Extension"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# TODO: package 'pytest_tornasync'
RESTRICT="test"

BDEPEND="dev-python/jupyter_packaging[${PYTHON_USEDEP}]"
RDEPEND="dev-python/jupyter_server[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
