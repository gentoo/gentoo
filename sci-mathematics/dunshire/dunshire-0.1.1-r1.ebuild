# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

inherit distutils-r1

DESCRIPTION="Python library to solve linear games over symmetric cones"
HOMEPAGE="http://michael.orlitzky.com/code/dunshire/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/cvxopt[${PYTHON_USEDEP}]"

# Tests run on the build host? Bug #693916. There's one doctest that
# uses a numpy matrix, sorry. That will be fixed in the next release.
# Otherwise numpy is not needed; the required interfaces are provided
# through cvxopt.
BDEPEND="test? (
	${RDEPEND}
	 dev-python/numpy[${PYTHON_USEDEP}]
)"

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	local DOCS=( doc/README.rst )
	distutils-r1_python_install_all
}

python_test() {
	esetup.py test
}
