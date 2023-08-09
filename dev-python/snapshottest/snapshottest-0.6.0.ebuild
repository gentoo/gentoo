# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Snapshot Testing utils for Python"
HOMEPAGE="
	https://github.com/syrusakbary/snapshottest/
	https://pypi.org/project/snapshottest/
"
SRC_URI="
	https://github.com/syrusakbary/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-0.6.0-remove-fastdiff.patch"
	"${FILESDIR}/${PN}-0.6.0-py3.12-imp.patch"
)

python_prepare_all() {
	sed -i -e 's:--cov snapshottest::' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	epytest tests examples/pytest
	"${EPYTHON}" examples/unittest/test_demo.py || die "Tests failed with ${EPYTHON}"
}
