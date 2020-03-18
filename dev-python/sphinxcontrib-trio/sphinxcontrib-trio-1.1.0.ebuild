# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Make Sphinx better at documenting Python functions and methods"
HOMEPAGE="
	https://github.com/python-trio/sphinxcontrib-trio
	https://pypi.org/project/sphinxcontrib-trio
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/contextlib2[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest
