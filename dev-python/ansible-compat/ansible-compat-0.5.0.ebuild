# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: 0.6.0+ support py3.10 upstream but as of 2021-11-18 we are still missing
# support for it in app-admin/ansible-base, add when ready
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Contains functions that facilitate working with various versions of Ansible"
HOMEPAGE="https://pypi.org/project/ansible-compat/ https://github.com/ansible-community/ansible-compat/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-admin/ansible-base-2.9.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/subprocess-tee-0.3.5[${PYTHON_USEDEP}]
"
BDEPEND="$(python_gen_cond_dep '
	>=dev-python/setuptools_scm-6.3.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-markdown[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-plus[${PYTHON_USEDEP}]
	)
')"

# Requires currently unpackaged Sphinx extension myst_parser
#distutils_enable_sphinx docs 'dev-python/sphinx_ansible_theme'

distutils_enable_tests pytest
