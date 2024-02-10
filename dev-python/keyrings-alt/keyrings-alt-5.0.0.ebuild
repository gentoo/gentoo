# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Alternate keyring implementations"
HOMEPAGE="
	https://github.com/jaraco/keyrings.alt/
	https://pypi.org/project/keyrings.alt/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/jaraco-classes[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-3.4.1[${PYTHON_USEDEP}]
	test? (
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# oldschool namespaces
	rm keyrings/__init__.py || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -k 'not Cryptodome'
}
