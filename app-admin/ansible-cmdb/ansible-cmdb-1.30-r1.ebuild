# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1

DESCRIPTION="Ansible Configuration Management Database"
HOMEPAGE="https://github.com/fboender/ansible-cmdb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/jsonxs[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
