# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Code audit tool for python"
HOMEPAGE="https://github.com/klen/pylama"
SRC_URI="https://github.com/klen/pylama/archive/${PV}.tar.gz -> ${P}.tar.gz"
# pypi tarball excludes unit tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/mccabe-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/pep257-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyflakes-1.5.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/eradicate-0.2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/radon-1.4.2[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test -v test_pylama.py || die "tests failed with ${EPYTHON}"
}
