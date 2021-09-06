# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

HOMEPAGE="https://github.com/requests/requests-kerberos/"
DESCRIPTION="A Kerberos authentication handler for python-requests"
SRC_URI="https://github.com/requests/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/requests-1.1.0[${PYTHON_USEDEP}]
	<dev-python/pykerberos-2[${PYTHON_USEDEP}]
	>=dev-python/pykerberos-1.1.8[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest
