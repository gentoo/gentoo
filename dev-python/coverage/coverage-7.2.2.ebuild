# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="threads(+),sqlite(+)"

inherit distutils-r1 pypi

DESCRIPTION="Code coverage measurement for Python"
HOMEPAGE="
	https://coverage.readthedocs.io/en/latest/
	https://github.com/nedbat/coveragepy/
	https://pypi.org/project/coverage/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{8..10})
"
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
	local EPYTEST_IGNORE=(
		# pip these days insists on fetching build deps from Internet
		tests/test_venv.py
	)

	"${EPYTHON}" igor.py zip_mods || die

	local -x COVERAGE_TESTING=True
	# TODO: figure out why they can't be imported inside test env
	local -x COVERAGE_NO_CONTRACTS=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=_hypothesis_pytestplugin,flaky.flaky_pytest_plugin,xdist.plugin

	local prev_opt=$(shopt -p nullglob)
	shopt -s nullglob
	local c_ext=( "${BUILD_DIR}/install$(python_get_sitedir)"/coverage/*.so )
	${prev_opt}

	if [[ -n ${c_ext} ]]; then
		cp "${c_ext}" \
			coverage/ || die
		test_tracer c
		rm coverage/*.so || die
	else
		test_tracer py
	fi
}
