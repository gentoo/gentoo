# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Check cryptographic keys for known weaknesses"
HOMEPAGE="https://badkeys.info/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dkim ssh"

DEPEND="dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/gmpy2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dkim? ( dev-python/dnspython[${PYTHON_USEDEP}] )
	ssh? ( dev-python/paramiko[${PYTHON_USEDEP}] )"
# TODO: add optional binary-file-search dependency once
# it is packaged.
DOCS=( README.md )

distutils_enable_tests unittest
