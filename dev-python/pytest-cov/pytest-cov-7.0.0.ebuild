# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin for coverage reporting"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-cov/
	https://pypi.org/project/pytest-cov/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/coverage-7.10.6[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.2[${PYTHON_USEDEP}]
	>=dev-python/pytest-7[${PYTHON_USEDEP}]
"
# NB: xdist is also used directly in the test suite
BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	test? (
		dev-python/fields[${PYTHON_USEDEP}]
		>=dev-python/process-tests-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/py-1.4.22[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/furo

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" pytest-xdist )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	# https://github.com/pytest-dev/pytest-cov/issues/517
	local sitedir="$(python_get_sitedir)"
	local -x PYTHONPATH="${BUILD_DIR}/install${sitedir}:${BROOT}${sitedir#${EPREFIX}}:${PYTHONPATH}"
	local -x PYTHONUSERBASE=/usr

	local EPYTEST_DESELECT=(
		# no celery in ::gentoo
		tests/test_pytest_cov.py::test_celery
		# TODO
		tests/test_pytest_cov.py::test_filterwarnings_error
	)

	case ${EPYTHON} in
		python3.14*)
			EPYTEST_DESELECT+=(
				# https://github.com/pytest-dev/pytest-cov/issues/719
				# (skipped previously)
				tests/test_pytest_cov.py::test_contexts
			)
			;;
	esac

	epytest
}
