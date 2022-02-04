# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1 optfeature

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible-community/ansible-lint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

# 14 tests fail due to usersandbox denying the executable 'ansible'
# access to $HOME/.ansible. More importantly, some tests (6 as of 5.2.1)
# fail even when run manually with tox.
RESTRICT="test"

RDEPEND="
	>=app-admin/ansible-2.10[${PYTHON_USEDEP}]
	>=app-admin/ansible-base-2.11.4[${PYTHON_USEDEP}]
	>=dev-python/enrich-1.2.6[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/rich-9.5.1[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.37[${PYTHON_USEDEP}]
	dev-python/tenacity[${PYTHON_USEDEP}]
	>=dev-python/wcmatch-7.0[${PYTHON_USEDEP}]"
BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/flaky-3.7.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.1.0[${PYTHON_USEDEP}]
		>=dev-util/yamllint-1.25.0[${PYTHON_USEDEP}]
	)"

distutils_enable_tests --install pytest

pkg_postinst() {
	optfeature_header "Consider installing the following optional packages:"
	optfeature "letting ${PN} run YAML checks" dev-util/yamllint
}
