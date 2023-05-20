# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="sphinx-ansible-theme"
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A reusable Ansible Sphinx theme"
HOMEPAGE="https://github.com/ansible-community/sphinx_ansible_theme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	doc? ( dev-python/ansible-pygments[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs 'dev-python/sphinx-notfound-page'
