# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="An implementation of QUIC and HTTP/3"
HOMEPAGE="
	https://github.com/aiortc/aioquic/
	https://pypi.org/project/aioquic/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND="
	dev-libs/openssl:=
"
RDEPEND="
	${DEPEND}
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/cryptography-42.0.0[${PYTHON_USEDEP}]
	<dev-python/pylsqpack-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/pylsqpack-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-24[${PYTHON_USEDEP}]
	>=dev-python/service-identity-24.1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
