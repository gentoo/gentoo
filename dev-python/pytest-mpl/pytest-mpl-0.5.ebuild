# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1 virtualx

DOCS=( README.md CHANGES.md )

DESCRIPTION="pytest plugin to faciliate image comparison for matplotlib figures"
HOMEPAGE="https://github.com/astrofrog/pytest-mpl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	echo "backend : Agg" > matplotlibrc || die
	MPLCONFIGDIR=. virtx py.test -v || die
}
