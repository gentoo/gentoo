# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="Password hashing framework supporting over 20 schemes"
HOMEPAGE="https://bitbucket.org/ecollins/passlib/wiki/Home/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
SLOT="0"
IUSE="+bcrypt doc +scrypt test +totp"

RDEPEND="bcrypt? ( dev-python/bcrypt[${PYTHON_USEDEP}] )
	totp? ( dev-python/cryptography[${PYTHON_USEDEP}] )
	scrypt? ( dev-python/scrypt[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests -w "${BUILD_DIR}"/lib || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && dodoc docs/{*.rst,requirements.txt,lib/*.rst}
}
