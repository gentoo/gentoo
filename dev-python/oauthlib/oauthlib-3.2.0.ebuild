# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Spec-compliant and thorough implementation of the OAuth request-signing logic"
HOMEPAGE="https://github.com/oauthlib/oauthlib https://pypi.org/project/oauthlib/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

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
