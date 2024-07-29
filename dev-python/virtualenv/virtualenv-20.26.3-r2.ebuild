# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Virtual Python Environment builder"
HOMEPAGE="
	https://virtualenv.pypa.io/en/stable/
	https://pypi.org/project/virtualenv/
	https://github.com/pypa/virtualenv/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

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
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		>=dev-python/pip-22.2.1[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/pytest-freezer-0.4.6[${PYTHON_USEDEP}]
		' pypy3)
		>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/setuptools-67.8[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/time-machine[${PYTHON_USEDEP}]
		' 'python3*')
		dev-python/wheel[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_TIMEOUT=180
distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# use wheels from ensurepip bundle
		"${FILESDIR}/${PN}-20.26.3-ensurepip.patch"
	)

	distutils-r1_src_prepare

	# workaround test failures due to warnings from setuptools-scm, sigh
	echo '[tool.setuptools_scm]' >> pyproject.toml || die

	# remove useless pins
	sed -i -e 's:<[0-9.]*,::' pyproject.toml || die

	# remove bundled wheels
	rm src/virtualenv/seed/wheels/embed/*.whl || die
}

python_test() {
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
	)
	case ${EPYTHON} in
		python3.1[23])
			EPYTEST_DESELECT+=(
				tests/unit/create/via_global_ref/test_build_c_ext.py
			)
			;&
		python3.11)
			EPYTEST_DESELECT+=(
				# TODO
				tests/unit/discovery/py_info/test_py_info.py::test_fallback_existent_system_executable
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x TZ=UTC
	local plugins=( -p flaky -p pytest_mock )
	if [[ ${EPYTHON} == pypy3 ]]; then
		plugins+=( -p freezer )
	else
		plugins+=( -p time_machine )
	fi
	epytest "${plugins[@]}" -p xdist -n "$(makeopts_jobs)" --dist=worksteal
}

src_install() {
	distutils-r1_src_install

	# remove bundled wheels, we're using ensurepip bundle instead
	find "${ED}" -name '*.whl' -delete || die
}
