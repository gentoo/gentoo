# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature

MY_PN="${PN#ansible-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A toolkit designed to aid in the development and testing of Ansible roles"
HOMEPAGE="https://pypi.org/project/molecule/ https://github.com/ansible-community/molecule/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="selinux"

RDEPEND="$(python_gen_cond_dep '
	>=dev-python/ansible-compat-2.2.0[${PYTHON_USEDEP}]
	dev-python/cerberus[${PYTHON_USEDEP}]
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	>=dev-python/click-help-colors-0.9[${PYTHON_USEDEP}]
	>=dev-python/enrich-1.2.7[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.11.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.9.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	<dev-python/pluggy-2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/rich-9.5.1[${PYTHON_USEDEP}]
	>=dev-util/cookiecutter-1.7.3[${PYTHON_USEDEP}]
	selinux? ( sys-libs/libselinux[python,${PYTHON_USEDEP}] )
')"
BDEPEND="$(python_gen_cond_dep '
	>=dev-python/setuptools_scm-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.1[${PYTHON_USEDEP}]
	doc? (
		app-admin/ansible-core[${PYTHON_USEDEP}]
		dev-python/ansible-pygments[${PYTHON_USEDEP}]
		>=dev-python/simplejson-3.17.2[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/ansi2html-1.6.0[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		<dev-python/pexpect-5[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-plus-0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-testinfra-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.1.0[${PYTHON_USEDEP}]
		dev-util/yamllint
	)
')"

S="${WORKDIR}"/${MY_P}

# test_role.py doesn't play nicely with FEATURES=usersandbox. As for test_command.py:
#  - quite a few of these tests use the network;
#  - test_command_dependency[shell] only works if Molecule has previously been installed;
#  - tests involving creation of a new scenario fail on ansible-lint errors, even though
#    a config file is deployed which should skip expected issues.
EPYTEST_DESELECT=(
	src/molecule/test/functional/test_command.py
	src/molecule/test/unit/command/init/test_role.py
)

distutils_enable_sphinx docs '>=dev-python/sphinx-notfound-page-0.7.1' '<dev-python/sphinx_ansible_theme-0.10.0'
distutils_enable_tests pytest

pkg_postinst() {
	optfeature_header "Some optional packages commonly used in Molecule scenarios:"
	optfeature "checking playbooks for practices and behaviour that can be improved" app-admin/ansible-lint
}
