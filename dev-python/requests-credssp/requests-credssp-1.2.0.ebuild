# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="HTTPS CredSSP authentication with the requests library"
HOMEPAGE="https://pypi.org/project/requests-credssp/"
# .gh for tests in github tarball, drop ".gh" on next bump
SRC_URI="https://github.com/jborean93/requests-credssp/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# Needs unpackaged pyspnego (https://github.com/jborean93/pyspnego)
RESTRICT="test"

RDEPEND="dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ntlm-auth[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

#distutils_enable_tests pytest
