# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

# please bump dev-python/ensurepip-setuptools along with this package!

DISTUTILS_USE_PEP517=standalone
PYTHON_TESTED=( python3_{9..11} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="
	https://github.com/pypa/setuptools/
	https://pypi.org/project/setuptools/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/jaraco-text-3.7.0-r1[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-8.12.0-r1[${PYTHON_USEDEP}]
	>=dev-python/nspektr-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/ordered-set-4.0.2-r1[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3-r2[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.6.2-r1[${PYTHON_USEDEP}]
	>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-4.11.1[${PYTHON_USEDEP}]
	' 3.9)
"
BDEPEND="
	${RDEPEND}
	>=dev-python/wheel-0.37.1-r1[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep '
			dev-python/build[${PYTHON_USEDEP}]
			>=dev-python/ini2toml-0.9[${PYTHON_USEDEP}]
			>=dev-python/filelock-3.4.0[${PYTHON_USEDEP}]
			>=dev-python/jaraco-envs-2.2[${PYTHON_USEDEP}]
			>=dev-python/jaraco-path-3.2.0[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
			dev-python/pip-run[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-fixture-config[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			>=dev-python/tomli-w-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-20[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"
PDEPEND="
	>=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

DOCS=( {CHANGES,README}.rst )

src_prepare() {
	local PATCHES=(
		# TODO: remove this when we're 100% PEP517 mode
		"${FILESDIR}"/setuptools-62.4.0-py-compile.patch
	)

	distutils-r1_src_prepare

	# remove bundled dependencies, setuptools will switch to system deps
	# automatically
	rm -r */_vendor || die

	# remove the ugly */extern hack that breaks on unvendored deps
	rm -r */extern || die
	find -name '*.py' -exec sed \
		-e 's:from \w*[.]\+extern ::' -e 's:\w*[.]\+extern[.]::' \
		-i {} + || die
}

python_test() {
	local -x SETUPTOOLS_USE_DISTUTILS=stdlib

	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		return
	fi

	local EPYTEST_DESELECT=(
		# network
		# TODO: see if PRE_BUILT_SETUPTOOLS_* helps
		setuptools/tests/config/test_apply_pyprojecttoml.py::test_apply_pyproject_equivalent_to_setupcfg
		setuptools/tests/integration/test_pip_install_sdist.py::test_install_sdist
		setuptools/tests/test_build_meta.py::test_legacy_editable_install
		setuptools/tests/test_distutils_adoption.py
		setuptools/tests/test_editable_install.py
		setuptools/tests/test_setuptools.py::test_its_own_wheel_does_not_contain_tests
		setuptools/tests/test_virtualenv.py::test_clean_env_install
		setuptools/tests/test_virtualenv.py::test_no_missing_dependencies
		setuptools/tests/test_virtualenv.py::test_test_command_install_requirements
		# TODO
		setuptools/tests/config/test_setupcfg.py::TestConfigurationReader::test_basic
		setuptools/tests/config/test_setupcfg.py::TestConfigurationReader::test_ignore_errors
		setuptools/tests/test_extern.py::test_distribution_picklable
		# expects bundled deps in virtualenv
		setuptools/tests/config/test_apply_pyprojecttoml.py::TestMeta::test_example_file_in_sdist
		setuptools/tests/config/test_apply_pyprojecttoml.py::TestMeta::test_example_file_not_in_wheel
		setuptools/tests/test_editable_install.py::test_editable_with_pyproject
		# fails if python-xlib is installed
		setuptools/tests/test_easy_install.py::TestSetupRequires::test_setup_requires_with_allow_hosts
	)

	if has_version "<dev-python/packaging-22"; then
		EPYTEST_DESELECT+=(
			# old packaging is more lenient
			setuptools/tests/config/test_setupcfg.py::TestOptions::test_raises_accidental_env_marker_misconfig
		)
	fi

	epytest -n "$(makeopts_jobs)" setuptools
}
