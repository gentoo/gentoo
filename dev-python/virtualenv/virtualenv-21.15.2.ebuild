# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/pypa/virtualenv
PYTHON_TESTED=( python3_{12..15} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" pypy3_12 python3_{14..15}t )

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
	>=dev-python/filelock-3.24.2[${PYTHON_USEDEP}]
	>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.9.1[${PYTHON_USEDEP}]
	>=dev-python/python-discovery-1.6[${PYTHON_USEDEP}]

	dev-python/ensurepip-pip
	>=dev-python/ensurepip-setuptools-70.1
	dev-python/ensurepip-wheel
"
# coverage is used somehow magically in virtualenv, maybe it actually
# tests something useful
BDEPEND="
	>=dev-python/hatch-fancy-pypi-readme-25.1[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/coverage[${PYTHON_USEDEP}]
			>=dev-python/hatchling-1.27[${PYTHON_USEDEP}]
			>=dev-python/pip-22.2.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-3.6.1[${PYTHON_USEDEP}]
			dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			>=dev-python/setuptools-67.8[${PYTHON_USEDEP}]
			dev-python/time-machine[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

src_prepare() {
	local PATCHES=(
		# use wheels from ensurepip bundle
		"${FILESDIR}/${PN}-21.5.1-ensurepip.patch"
	)

	distutils-r1_src_prepare

	# workaround test failures due to warnings from setuptools-scm, sigh
	echo '[tool.setuptools_scm]' >> pyproject.toml || die

	# remove useless pins
	sed -i -e 's:,<[=0-9.]*::' pyproject.toml || die

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
		tests/unit/seed/wheels/test_wheels_util.py::test_embed_wheel_below_oldest_supported_is_missing
		# hangs on a busy system, sigh
		tests/unit/test_util.py::test_reentrant_file_lock_is_thread_safe
		# TODO
		tests/unit/create/via_global_ref/test_build_c_ext.py::test_can_build_c_extensions
		# random resource leaks or xdist
		tests/unit/test_file_limit.py::test_too_many_open_files
		# Internet
		tests/unit/create/test_creator.py::test_create_distutils_cfg
		tests/unit/seed/embed/test_pip_invoke.py::test_pip_reseed_removes_previous_version_metadata
		# we do not use bundled wheels
		tests/unit/seed/wheels/test_bundle.py::test_every_wheel_on_disk_has_sha256
		tests/unit/seed/embed/test_bootstrap_link_via_app_data.py::test_seed_image_build_direct_call
		# requires bundled packages in pip
		tests/unit/test_sbom.py::test_sbom_spdx_declared_license
		# require pre-commit = internet
		tests/unit/test_wheel_age.py::test_generator_converges
		tests/unit/test_wheel_age.py::test_generator_updates_license
		# TODO
		tests/unit/seed/embed/test_bootstrap_link_via_app_data.py::test_pip_launcher_record_matches_contents
		tests/unit/seed/wheels/test_acquire.py::test_download_wheel_skips_local_pip_module
		tests/unit/seed/wheels/test_acquire_find_wheel.py::test_find_latest
		# some platformdirs nonsense (bundled packages?)
		tests/unit/config/test___main__.py::test_module_entry_from_target_install
		# these all timeout; they may require xonsh or be plain broken
		tests/property/test_activation_prompt.py::test_prompt_seeds_stay_data
		tests/property/test_activation_prompt.py::test_prompt_stays_data
		tests/unit/activation/test_activator.py::test_activator_prompt_stays_data
	)

	local -x TZ=UTC
	local EPYTEST_PLUGINS=( pytest-{mock,rerunfailures} time-machine )
	local EPYTEST_RERUNS=5
	local EPYTEST_TIMEOUT=180
	local EPYTEST_XDIST=1
	epytest -o addopts=
}

src_install() {
	distutils-r1_src_install

	# remove bundled wheels, we're using ensurepip bundle instead
	find "${ED}" -name '*.whl' -delete || die
}
