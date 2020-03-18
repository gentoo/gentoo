# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A py.test plugin to validate Jupyter notebooks"
HOMEPAGE="https://github.com/computationalmodelling/nbval"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)"
