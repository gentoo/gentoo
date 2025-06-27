# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..13} )
PYPI_PN="molecule"

inherit distutils-r1 optfeature pypi

DESCRIPTION="A toolkit designed to aid in the development and testing of Ansible roles"
HOMEPAGE="https://pypi.org/project/molecule/ https://github.com/ansible/molecule/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="selinux"

# Since around the time of the switch to the yy.m.patchlevel versioning scheme
# the test suite has been completely incompatible with Portage, with several
# tests which do pass under Tox failing even with disabled sandboxing.
# Nb. As of 24.2.1 two tests fail even under Tox, for both PyPI and GitHub
# tarballs.
RESTRICT="test"

RDEPEND="
	>=app-admin/ansible-core-2.18.1[${PYTHON_USEDEP}]
	>=dev-python/ansible-compat-25.5.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	<dev-python/click-9[${PYTHON_USEDEP}]
	>=dev-python/click-help-colors-0.9[${PYTHON_USEDEP}]
	>=dev-python/enrich-1.2.7[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.9.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	<dev-python/pluggy-2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.1-r1[${PYTHON_USEDEP}]
	>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-8.2.5[${PYTHON_USEDEP}]
	selinux? ( sys-libs/libselinux[python,${PYTHON_USEDEP}] )
"
BDEPEND="
	>=dev-python/setuptools-scm-7.0.5[${PYTHON_USEDEP}]
	test? (
		>=app-admin/ansible-lint-25.5.0[${PYTHON_USEDEP}]
		>=app-misc/check-jsonschema-0.28.4-r1[${PYTHON_USEDEP}]
		>=dev-python/ansi2html-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/filelock-3.9.0[${PYTHON_USEDEP}]
		<dev-python/pexpect-5[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-plus-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.1.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-24.2.1-mkdocs_google_fonts.patch
)

# test_role.py doesn't play nicely with FEATURES=usersandbox. As for test_command.py:
#  - quite a few of these tests use the network;
#  - test_command_dependency[shell] only works if Molecule has previously been installed;
#  - tests involving creation of a new scenario fail on ansible-lint errors, even though
#    a config file is deployed which should skip expected issues.
EPYTEST_DESELECT=(
	src/molecule/test/functional/test_command.py
	src/molecule/test/unit/command/init/test_role.py
)

distutils_enable_tests pytest

pkg_postinst() {
	optfeature_header "Some optional packages commonly used in Molecule scenarios:"
	optfeature "checking playbooks for practices and behaviour that can be improved" app-admin/ansible-lint
}
