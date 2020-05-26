# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} pypy3 )

inherit distutils-r1

DESCRIPTION="Password hashing framework supporting over 20 schemes"
HOMEPAGE="https://bitbucket.org/ecollins/passlib/wiki/Home/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc x86"
SLOT="0"
IUSE="+bcrypt doc +scrypt +totp"

RDEPEND="bcrypt? ( dev-python/bcrypt[${PYTHON_USEDEP}] )
	totp? ( dev-python/cryptography[${PYTHON_USEDEP}] )
	scrypt? ( dev-python/scrypt[${PYTHON_USEDEP}] )"
BDEPEND="
	test? (
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/scrypt[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/passlib-1.7.2-pypy3.patch"
	"${FILESDIR}/passlib-1.7.2-py39.patch"
)

distutils_enable_tests nose

python_install_all() {
	distutils-r1_python_install_all
	use doc && dodoc docs/{*.rst,requirements.txt,lib/*.rst}
}
