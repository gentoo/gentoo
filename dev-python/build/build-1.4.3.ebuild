# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_TESTED=( python3_{11..14} pypy3_11 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_{13,14}t )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="A simple, correct PEP517 package builder"
HOMEPAGE="
	https://pypi.org/project/build/
	https://github.com/pypa/build/
"
SRC_URI="
	https://github.com/pypa/build/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test test-rust"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
	dev-python/pyproject-hooks[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-6[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			>=dev-python/filelock-3[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-2[${PYTHON_USEDEP}]
			>=dev-python/pytest-rerunfailures-9.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-1.34[${PYTHON_USEDEP}]
			>=dev-python/setuptools-56.0.0[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
			>=dev-python/wheel-0.36.0[${PYTHON_USEDEP}]
			test-rust? (
				!s390? ( !sparc? ( >=dev-python/uv-0.1.18 ) )
			)
		' "${PYTHON_TESTED[@]}")
	)
"

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_DESELECT=(
		# broken by uv being installed outside venv
		tests/test_env.py::test_external_uv_detection_success
	)

	if ! has_version "dev-python/uv"; then
		EPYTEST_DESELECT+=(
			tests/test_env.py::test_uv_impl_install_cmd_well_formed
			'tests/test_env.py::test_venv_creation[uv-venv+uv-None]'
		)
	fi

	local EPYTEST_PLUGINS=( pytest-{mock,rerunfailures} )
	local EPYTEST_XDIST=1
	epytest -m "not network"
}
