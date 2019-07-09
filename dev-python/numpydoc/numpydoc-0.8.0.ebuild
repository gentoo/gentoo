# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Sphinx extension to support docstrings in Numpy format"
HOMEPAGE="https://pypi.org/project/numpydoc/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-1.4.0[${PYTHON_USEDEP}]
	)"

python_test() {
	esetup.py test
}
