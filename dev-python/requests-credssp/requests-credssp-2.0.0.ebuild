# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="HTTPS CredSSP authentication with the requests library"
HOMEPAGE="
	https://pypi.org/project/requests-credssp/
	https://github.com/jborean93/requests-credssp/
"
SRC_URI="
	https://github.com/jborean93/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/gssapi[${PYTHON_USEDEP}]
	dev-python/krb5[${PYTHON_USEDEP}]
	>=dev-python/pyspnego-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
