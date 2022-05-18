# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible/ansible-lint"
# PyPI tarballs do not contain all the data files needed by the tests
SRC_URI="https://github.com/ansible/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

# Since 6.0.2, access to Ansible Galaxy (i.e. the Internet) is required even to get
# the test suite started (Bug #836582). TODO: Talk to upstream about how to bypass this.
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=app-admin/ansible-base-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/ansible-compat-2.0.3[${PYTHON_USEDEP}]
	>=dev-python/enrich-1.2.6[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.5.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/rich-9.5.1[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.37[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-7.0[${PYTHON_USEDEP}]
	>=dev-util/yamllint-1.25.0[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/setuptools_scm-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/flaky-3.7.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-plus-0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.5.0[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.2_test-module-check.patch
)

# Skip problematic tests:
#  - test_call_from_outside_venv doesn't play nicely with the sandbox
#  - all test_eco and some test_prerun tests require Internet access
#  - as of 5.4.0, test_cli_auto_detect fails even when run manually with tox
EPYTEST_DESELECT=(
	test/test_eco.py
	test/test_main.py::test_call_from_outside_venv
	test/test_prerun.py::test_install_collection
	test/test_prerun.py::test_prerun_reqs_v1
	test/test_prerun.py::test_prerun_reqs_v2
	test/test_prerun.py::test_require_collection_wrong_version
	test/test_utils.py::test_cli_auto_detect
)

distutils_enable_tests pytest

python_test() {
	# For some reason the schema files do not get installed in spite of being present in release tarballs,
	# with the test suite relying on "refreshing" them (i.e. downloading them from the Internet) instead
	# - and seemingly occasionally failing to do even that right. Just stick with the bundled files.
	# TODO: check if this is still needed every new release.
	local schemadir="${BUILD_DIR}/install/$(python_get_sitedir)/ansiblelint/schemas/"
	cp src/ansiblelint/schemas/*.json "${schemadir}" || die

	epytest test

	# Make sure src_install() does not install these regardless of whether src_test() has run or not.
	rm "${schemadir}"/*.json || die
}
