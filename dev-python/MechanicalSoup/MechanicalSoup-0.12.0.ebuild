# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A python library for automating interaction with websites"
HOMEPAGE="https://pypi.org/project/MechanicalSoup/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/beautifulsoup-4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		>=dev-python/requests-mock-1.3.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs

python_prepare_all() {
	# We don't need pytest-runner to run tests via pytest
	sed -i "s/'pytest-runner'//" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Override pytest options to skip coverage and flake8
	pytest -vv --override-ini="addopts=" \
		|| die "tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
