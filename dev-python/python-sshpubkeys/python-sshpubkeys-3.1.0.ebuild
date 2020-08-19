# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="OpenSSH public key parser for Python"
HOMEPAGE="https://pypi.org/project/sshpubkeys/ https://github.com/ojarva/python-sshpubkeys"
SRC_URI="https://github.com/ojarva/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
