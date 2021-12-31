# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6}} )

inherit distutils-r1 virtualx

DOCS=( README.rst CHANGES.md )

DESCRIPTION="pytest plugin to faciliate image comparison for matplotlib figures"
HOMEPAGE="https://github.com/astrofrog/pytest-mpl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	echo "backend : Agg" > "${T}"/matplotlibrc || die
	MPLCONFIGDIR="${T}" virtx py.test -v
}
