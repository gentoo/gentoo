# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Wrappers to build Python packages using PEP 517 hooks"
HOMEPAGE="
	https://pypi.org/project/pep517/
	https://github.com/pypa/pep517/
	https://pep517.readthedocs.io/"
SRC_URI="
	https://github.com/pypa/pep517/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/tomli[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/testpath[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# require Internet
	tests/test_meta.py
)

src_prepare() {
	sed -i -e '/--flake8/d' pytest.ini || die
	distutils-r1_src_prepare
}
