# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Python libraries and CLI to interact with the REST API of a Girder server"
HOMEPAGE="https://girder.readthedocs.io/en/latest/python-client.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

# see https://github.com/girder/girder/tree/master/clients/python
RDEPEND="
	>=dev-python/click-6.7[${PYTHON_USEDEP}]
	>=dev-python/diskcache-1.6.7[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
