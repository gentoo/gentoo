# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A complete yet simple CSS parser for Python"
HOMEPAGE="https://github.com/Kozea/tinycss2/ https://pypi.python.org/pypi/tinycss2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/webencodings-0.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-39.2.0[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-flake8[${PYTHON_USEDEP}]
		dev-python/pytest-isort[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst )

python_test() {
	py.test || die "testsuite failed under ${EPYTHON}"
}
