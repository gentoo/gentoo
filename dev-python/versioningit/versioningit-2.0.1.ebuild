# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A setuptools plugin for versioning based on git tags"
HOMEPAGE="
	https://github.com/jwodder/versioningit/
	https://pypi.org/project/versioningit/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/packaging-17.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# Tries to do wheel/pip installs
	test/test_end2end.py
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -i \
		-e '/--cov/d' \
		-e '/-cov-/d' \
		tox.ini || die

	distutils-r1_python_prepare_all
}

python_test() {
	epytest -p no:pytest-describe
}
