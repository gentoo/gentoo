# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=MechanicalSoup
PYTHON_COMPAT=( python3_{12..15} )

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
	>=dev-python/certifi-2022.12.7[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-2.2.2[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-{httpbin,mock} requests-mock )
distutils_enable_tests pytest
distutils_enable_sphinx docs

python_test() {
	local EPYTEST_DESELECT=(
		# random regression (deps?)
		tests/test_stateful_browser.py::test_select_form_associated_elements
	)

	epytest -o addopts=
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
