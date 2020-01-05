# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

HOMEPAGE="https://pypi.org/project/requests-kerberos/"
DESCRIPTION="A Kerberos authentication handler for python-requests"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-python/requests-1.1.0[${PYTHON_USEDEP}]
	|| ( >=dev-python/pykerberos-1.1.8[${PYTHON_USEDEP}] <dev-python/pykerberos-2[${PYTHON_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
