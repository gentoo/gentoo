# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6}} )

inherit distutils-r1

DESCRIPTION="N-D labeled arrays and datasets in Python"
HOMEPAGE="http://xarray.pydata.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/numpy-1.14[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/dask-0.18.2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' 'python2*')
	)"

PATCHES=(
	"${FILESDIR}/${PN}-0.10.8-skip-broken-test.patch"
)

python_test() {
	pytest -v || die
}
