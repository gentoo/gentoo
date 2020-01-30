# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6,7,8} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="A next generation HTTP client for Python. butterfly"
HOMEPAGE="https://www.python-httpx.org"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="brotli"

RDEPEND="
    >=dev-python/certifi-2017.4.17[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.0[${PYTHON_USEDEP}]
    >=dev-python/rfc3986-1.3[${PYTHON_USEDEP}]
    <dev-python/rfc3986-2.0[${PYTHON_USEDEP}]
    >=dev-python/h11-0.8[${PYTHON_USEDEP}]
    <dev-python/h11-0.10[${PYTHON_USEDEP}]
    >=dev-python/hyper-h2-3.0[${PYTHON_USEDEP}]
    dev-python/hstspreload[${PYTHON_USEDEP}]
    dev-python/sniffio[${PYTHON_USEDEP}]
    brotli? ( dev-python/brotlipy[${PYTHON_USEDEP}] )
"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
