# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_TESTED=( pypy3 python3_{10..12} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

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
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}/backend

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

# deps are listed in backend/src/hatchling/ouroboros.py
# editables are optional but required for editable installs
RDEPEND="
	>=dev-python/editables-0.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/pluggy-1.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.2.2[${PYTHON_USEDEP}]
	' 3.10)
	dev-python/trove-classifiers[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/atomicwrites[${PYTHON_USEDEP}]
			dev-python/click[${PYTHON_USEDEP}]
			dev-python/httpx[${PYTHON_USEDEP}]
			dev-python/platformdirs[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
			dev-python/tomli-w[${PYTHON_USEDEP}]
			dev-python/virtualenv[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

distutils_enable_tests pytest

python_test() {
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
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
		# broken if CARGO is set
		tests/backend/builders/test_binary.py::TestBuildBootstrap::test_no_cargo
	)

	# top-level "tests" directory contains tests both for hatch
	# and hatchling
	cd "${WORKDIR}/${MY_P}" || die
	local -x PYTHONPATH="src:${PYTHONPATH}"
	# sigh; standalone test suites are overrated, right?
	echo "__version__ = '${PV}'" > src/hatch/_version.py || die
	# tests mock cargo subprocess call but the backend raises if CARGO
	# is not set and shutil.which() can't find it
	local -x CARGO=cargo
	epytest tests/backend
}
