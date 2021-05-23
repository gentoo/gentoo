# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

# no tests on pypi, no tags on github
COMMIT_HASH="4ac2b4fb09e9e7728bebb11967c164a914775d1d"

DESCRIPTION="Snapshot Testing utils for Python"
HOMEPAGE="https://pypi.org/project/snapshottest/
	https://github.com/syrusakbary/snapshottest"
SRC_URI="
	https://github.com/syrusakbary/${PN}/archive/${COMMIT_HASH}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/snapshottest-0.5.1-remove-fastdiff.patch"
)

python_prepare_all() {
	sed -e "s:'pytest-runner'(,|)::" -i setup.py || die
	sed -r -e 's:--cov[[:space:]]*[[:graph:]]+::g' -i setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	epytest tests examples/pytest
	"${EPYTHON}" examples/unittest/test_demo.py || die "Tests failed with ${EPYTHON}"
}
