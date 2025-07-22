# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_TESTED=( python3_{11..14} pypy3_11 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_{13,14}t )

inherit distutils-r1 pypi

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="
	https://virtualenv.pypa.io/en/stable/
	https://pypi.org/project/virtualenv/
	https://github.com/pypa/virtualenv/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/distlib-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/filelock-3.12.2[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.9.1[${PYTHON_USEDEP}]

	dev-python/ensurepip-pip
	dev-python/ensurepip-setuptools
	dev-python/ensurepip-wheel
"
# coverage is used somehow magically in virtualenv, maybe it actually
# tests something useful
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/flaky[${PYTHON_USEDEP}]
			>=dev-python/pip-22.2.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			>=dev-python/setuptools-67.8[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
		$(python_gen_cond_dep '
			dev-python/time-machine[${PYTHON_USEDEP}]
		' python3_{11..13})
		$(python_gen_cond_dep '
			>=dev-python/pytest-freezer-0.4.6[${PYTHON_USEDEP}]
		' 'pypy3*')
	)
"

src_prepare() {
	local PATCHES=(
		# use wheels from ensurepip bundle
		"${FILESDIR}/${PN}-20.31.1-ensurepip.patch"
	)

	distutils-r1_src_prepare

	# workaround test failures due to warnings from setuptools-scm, sigh
	echo '[tool.setuptools_scm]' >> pyproject.toml || die

	# remove useless pins
	sed -i -e 's:,<[0-9.]*::' pyproject.toml || die

	# remove bundled wheels
	rm src/virtualenv/seed/wheels/embed/*.whl || die
}

python_test() {
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping testing on ${EPYTHON}"
		return
	fi

	local EPYTEST_DESELECT=(
		tests/unit/seed/embed/test_bootstrap_link_via_app_data.py::test_seed_link_via_app_data
		# tests for old wheels with py3.7 support
		tests/unit/seed/embed/test_pip_invoke.py::test_base_bootstrap_via_pip_invoke
		tests/unit/seed/wheels/test_wheels_util.py::test_wheel_not_support
		# broken by different wheel versions in ensurepip
		tests/unit/seed/wheels/test_acquire_find_wheel.py::test_find_latest_string
		tests/unit/seed/wheels/test_acquire_find_wheel.py::test_find_exact
		tests/unit/seed/wheels/test_acquire_find_wheel.py::test_find_latest_none
		tests/unit/seed/wheels/test_acquire.py::test_download_wheel_bad_output
		# hangs on a busy system, sigh
		tests/unit/test_util.py::test_reentrant_file_lock_is_thread_safe
		# TODO
		tests/unit/create/via_global_ref/test_build_c_ext.py::test_can_build_c_extensions
	)
	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# these don't like the executable called pypy3.11?
				tests/unit/activation/test_bash.py::test_bash
				tests/unit/activation/test_fish.py::test_fish
				tests/unit/discovery/py_info/test_py_info.py::test_fallback_existent_system_executable
			)
			;;
	esac

	local -x TZ=UTC
	local EPYTEST_PLUGINS=( flaky pytest-mock )
	if [[ ${EPYTHON} == pypy3* ]]; then
		EPYTEST_PLUGINS+=( pytest-freezer )
	else
		EPYTEST_PLUGINS+=( time-machine )
	fi
	local EPYTEST_TIMEOUT=180
	local EPYTEST_XDIST=1
	epytest "${plugins[@]}"
}

src_install() {
	distutils-r1_src_install

	# remove bundled wheels, we're using ensurepip bundle instead
	find "${ED}" -name '*.whl' -delete || die
}
