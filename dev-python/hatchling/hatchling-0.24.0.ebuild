# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

TAG=${P/-/-v}
MY_P=hatch-${TAG}
DESCRIPTION="Modern, extensible Python build backend"
HOMEPAGE="
	https://pypi.org/project/hatchling/
	https://github.com/pypa/hatch/
"
SRC_URI="
	https://github.com/pypa/hatch/archive/${TAG}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}/backend

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/editables-0.2[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.9[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.2.2[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/atomicwrites[${PYTHON_USEDEP}]
			dev-python/click[${PYTHON_USEDEP}]
			dev-python/httpx[${PYTHON_USEDEP}]
			dev-python/platformdirs[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
			dev-python/tomli-w[${PYTHON_USEDEP}]
			dev-python/virtualenv[${PYTHON_USEDEP}]
		' pypy3 python3_{8..10}  # TODO: 3.11 when deps are ported
		)
	)
"

distutils_enable_tests pytest

python_test() {
	if ! has "${EPYTHON}" pypy3 python3.{8..10}; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local -x EPYTEST_DESELECT=(
		# these run pip to install stuff
		tests/backend/dep/test_core.py::test_dependency_found
		tests/backend/dep/test_core.py::test_extra_met
		tests/backend/dep/test_core.py::test_extra_no_dependencies
		tests/backend/dep/test_core.py::test_extra_unmet
		tests/backend/dep/test_core.py::test_unknown_extra
		tests/backend/dep/test_core.py::test_version_unmet
	)

	# top-level "tests" directory contains tests both for hatch
	# and hatchling
	cd "${WORKDIR}/${MY_P}" || die
	local -x PYTHONPATH="src:${PYTHONPATH}"
	epytest tests/backend
}
