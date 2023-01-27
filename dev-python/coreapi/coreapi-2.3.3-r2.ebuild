# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=python-client-${PV}
DESCRIPTION="Python client library for Core API"
HOMEPAGE="https://github.com/core-api/python-client"
SRC_URI="
	https://github.com/core-api/python-client/archive/${PV}.tar.gz
		-> core-api-${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/coreschema[${PYTHON_USEDEP}]
	dev-python/itypes[${PYTHON_USEDEP}]
	dev-python/uritemplate[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
