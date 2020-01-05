# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python library to solve linear games over symmetric cones"
HOMEPAGE="http://michael.orlitzky.com/code/dunshire"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/cvxopt[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	local DOCS=( doc/README.rst )
	distutils-r1_python_install_all
}

python_test() {
	esetup.py test
}
