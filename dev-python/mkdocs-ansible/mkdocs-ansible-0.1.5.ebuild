# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Ansible theme for MkDocs"
HOMEPAGE="https://pypi.org/project/mkdocs-ansible/ https://github.com/ansible/mkdocs-ansible"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-python/mkdocs-material[${PYTHON_USEDEP}]"
