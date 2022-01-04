# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="${PN//_/-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A reusable Ansible Sphinx theme"
HOMEPAGE="https://github.com/ansible-community/sphinx_ansible_theme"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	doc? ( dev-python/ansible-pygments[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs 'dev-python/sphinx-notfound-page'
