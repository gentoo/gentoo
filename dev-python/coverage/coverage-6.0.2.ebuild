# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="threads(+),sqlite(+)"
inherit distutils-r1

DESCRIPTION="Code coverage measurement for Python"
HOMEPAGE="https://coverage.readthedocs.io/en/latest/ https://pypi.org/project/coverage/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
#IUSE="test"
# The tests are impossible to appease.  Please run them externally
# via tox.  Or fix the ebuild if you have hours of time to spend
# on something utterly useless.
RESTRICT="test"

#BDEPEND="
#	test? (
#		dev-python/PyContracts[${PYTHON_USEDEP}]
#		dev-python/flaky[${PYTHON_USEDEP}]
#		dev-python/hypothesis[${PYTHON_USEDEP}]
#		dev-python/mock[${PYTHON_USEDEP}]
#		dev-python/pytest[${PYTHON_USEDEP}]
#		>=dev-python/unittest-mixins-1.4[${PYTHON_USEDEP}]
#	)
#"

src_prepare() {
	# avoid the dep on xdist, run tests verbosely
	sed -i -e '/^addopts/s:-n3:-v:' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing

	"${EPYTHON}" igor.py zip_mods || die
	"${EPYTHON}" igor.py test_with_tracer py || die

	# No C extensions under pypy
	if [[ ${EPYTHON} != pypy* ]]; then
		cp -l -- "${TEST_DIR}"/lib/*/coverage/*.so coverage/ || die
		"${EPYTHON}" igor.py test_with_tracer c || die
	fi

	# clean up leftover "egg1" directory
	rm -rf build/lib/egg1 || die
}
