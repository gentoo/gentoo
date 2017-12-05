# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="https://github.com/ipython/ipykernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/traitlets[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/ipython-4.0.0[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '<dev-python/ipython-6[${PYTHON_USEDEP}]' 'python2*')
		dev-python/nose[${PYTHON_USEDEP}]
	)
	"

python_test() {
	nosetests --verbose ipykernel || die
}
