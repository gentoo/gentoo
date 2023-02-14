# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_PN="${PN//_/-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A reusable Ansible Sphinx theme"
HOMEPAGE="
	https://github.com/ansible-community/sphinx_ansible_theme/
	https://pypi.org/project/sphinx-ansible-theme/
"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-7.0.5[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	'dev-python/ansible-pygments' \
	'dev-python/sphinx-notfound-page'
