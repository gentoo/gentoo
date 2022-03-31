# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="threads(+),sqlite(+)"

inherit distutils-r1

DESCRIPTION="Code coverage measurement for Python"
HOMEPAGE="https://coverage.readthedocs.io/en/latest/ https://pypi.org/project/coverage/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

BDEPEND="
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/unittest-mixins-1.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/^addopts/s:-q -n auto::' setup.cfg || die
	distutils-r1_src_prepare
}

test_tracer() {
	local -x COVERAGE_TEST_TRACER=${1}
	einfo "  Testing with the ${COVERAGE_TEST_TRACER} tracer ..."
	epytest tests
}

python_test() {
	"${EPYTHON}" igor.py zip_mods || die

	local -x COVERAGE_TESTING=True
	# TODO: figure out why they can't be imported inside test env
	local -x COVERAGE_NO_CONTRACTS=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=_hypothesis_pytestplugin,flaky.flaky_pytest_plugin,xdist.plugin

	if [[ ${EPYTHON} != pypy* ]]; then
		cp "${BUILD_DIR}/install$(python_get_sitedir)"/coverage/*.so \
			coverage/ || die
		test_tracer c
		rm coverage/*.so || die
	else
		test_tracer py
	fi
}
