# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Tenable API Library for Tenable.io and SecurityCenter"
HOMEPAGE="https://github.com/tenable/pyTenable"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/requests-2.19[${PYTHON_USEDEP}]
	>=dev-python/requests_pkcs12-1.3[${PYTHON_USEDEP}]
	>=dev-python/semver-2.8.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

# requires networking and API endpoint
RESTRICT="test"
