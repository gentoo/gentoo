# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Spec-compliant and thorough implementation of the OAuth request-signing logic"
HOMEPAGE="https://github.com/idan/oauthlib https://pypi.org/project/oauthlib/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

# optional extras hard set as RDEPs. See setup.py
RDEPEND="
	>=dev-python/pyjwt-1.0.0[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest
