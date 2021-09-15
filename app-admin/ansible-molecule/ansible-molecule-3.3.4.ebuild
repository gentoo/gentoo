# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

MY_PN="${PN#ansible-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A toolkit designed to aid in the development and testing of Ansible roles"
HOMEPAGE="https://pypi.org/project/molecule/ https://github.com/ansible-community/molecule/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="selinux"

RDEPEND="$(python_gen_cond_dep '
	>=app-admin/ansible-lint-5.0.12[${PYTHON_USEDEP}]
	<dev-python/cerberus-1.3.3[${PYTHON_USEDEP}]
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	dev-python/click-help-colors[${PYTHON_USEDEP}]
	dev-python/enrich[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	<dev-python/paramiko-3[${PYTHON_USEDEP}]
	<dev-python/pluggy-1.0[${PYTHON_USEDEP}]
	<dev-python/pyyaml-6[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/subprocess-tee[${PYTHON_USEDEP}]
	>=dev-util/cookiecutter-1.7.3[${PYTHON_USEDEP}]
	selinux? ( sys-libs/libselinux[python,${PYTHON_USEDEP}] )
')"
BDEPEND="$(python_gen_cond_dep '
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	doc? (
		dev-python/simplejson[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/ansi2html[${PYTHON_USEDEP}]
		<dev-python/pexpect-5[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		>=dev-python/pytest-html-3.0.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-plus[${PYTHON_USEDEP}]
		dev-python/pytest-testinfra[${PYTHON_USEDEP}]
		dev-python/pytest-verbose-parametrize[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
')"

S="${WORKDIR}"/${MY_P}

distutils_enable_sphinx docs '>=dev-python/sphinx-notfound-page-0.7.1' 'dev-python/sphinx_ansible_theme'
distutils_enable_tests --install pytest

src_prepare() {
	default

	if ! use selinux; then
		sed -i "/^\s\+selinux/d" setup.cfg || die "Failed to remove dependency on SELinux"
	fi

	# Several issues with tests from this file:
	#  - quite a few of these use the network;
	#  - test_command_dependency[shell] only works if Molecule has previously been installed;
	#  - tests involving creation of a new scenario fail on ansible-lint errors, even though
	#    a config file is deployed which should skip expected issues.
	rm -f src/molecule/test/functional/test_command.py
	# Uses unpackaged yamllint
	rm -f src/molecule/test/unit/cookiecutter/test_molecule.py
}

python_test() {
	distutils_install_for_testing --via-venv
	distutils-r1_python_test
}
