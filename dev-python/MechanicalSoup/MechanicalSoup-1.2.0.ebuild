# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A Python library for automating interaction with websites"
HOMEPAGE="
	https://github.com/MechanicalSoup/MechanicalSoup/
	https://pypi.org/project/MechanicalSoup/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	>=dev-python/beautifulsoup4-4.7[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
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
	sed -e '/^addopts =/d' -i setup.cfg || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
