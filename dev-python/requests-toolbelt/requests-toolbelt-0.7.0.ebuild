# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5} )

inherit distutils-r1

DESCRIPTION="A utility belt for advanced users of python-requests"
HOMEPAGE="https://toolbelt.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="<=dev-python/requests-3.0.0"

DOCS=( AUTHORS.rst HISTORY.rst README.rst )
