# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="DKIM and ARC email signing and verification library"
HOMEPAGE="https://launchpad.net/dkimpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

DEPEND="
	dev-python/dnspython[${PYTHON_USEDEP}]
	extras? (
	dev-python/authres[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
)
"
RDEPEND="${DEPEND}"

distutils_enable_tests unittest

DEPEND+="
	test? (
	dev-python/authres[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
)"
