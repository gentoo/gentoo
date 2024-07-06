# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="DKIM and ARC email signing and verification library"
HOMEPAGE="
	https://launchpad.net/dkimpy/
	https://pypi.org/project/dkimpy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/dnspython-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/authres[${PYTHON_USEDEP}]
		dev-python/pynacl[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

pkg_postinst() {
	optfeature "ARC support" dev-python/authres
	optfeature "ed25519 capability" dev-python/pynacl
	optfeature "asyncio support" dev-python/aiodns
}
