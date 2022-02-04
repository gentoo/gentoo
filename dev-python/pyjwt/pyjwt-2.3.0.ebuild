# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature

MY_PN="PyJWT"
DESCRIPTION="JSON Web Token implementation in Python"
HOMEPAGE="https://github.com/jpadilla/pyjwt/ https://pypi.org/project/PyJWT/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ~ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="!dev-python/python-jwt"
BDEPEND="
	test? (
		>=dev-python/cryptography-3.3.1[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "cryptography" dev-python/cryptography
}
