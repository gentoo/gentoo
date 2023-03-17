# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Mock out responses from the requests package"
HOMEPAGE="https://github.com/jamielennox/requests-mock"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/requests-2.3[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/requests-futures[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc/source
distutils_enable_tests pytest

python_prepare_all() {
	# Disable reno which only works inside a git repository
	sed -i "s/'reno.sphinxext',//" doc/source/conf.py || die
	# Remove the release notes section which requires reno
	rm doc/source/release-notes.rst || die
	sed -i '/^=============$/,/release-notes/d' doc/source/index.rst || die
	# Disable a test which requires purl (not in the tree)
	sed -e "/^import purl$/d" -e "s/test_with_purl/_&/" \
		-i tests/test_adapter.py || die
	distutils-r1_python_prepare_all
}
