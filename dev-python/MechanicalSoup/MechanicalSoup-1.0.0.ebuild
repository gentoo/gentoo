# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A python library for automating interaction with websites"
HOMEPAGE="https://pypi.org/project/MechanicalSoup/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	>=dev-python/beautifulsoup-4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/requests-mock-1.3.0[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	# Override pytest options to skip coverage and flake8
	sed -i -e '/^addopts =/d' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
