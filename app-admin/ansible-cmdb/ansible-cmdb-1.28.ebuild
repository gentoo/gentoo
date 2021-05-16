# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_7,3_8} )

inherit distutils-r1

DESCRIPTION="Ansible Configuration Management Database"
HOMEPAGE="https://github.com/fboender/ansible-cmdb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/jsonxs[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
