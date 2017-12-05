# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Implementation of the password-based key derivation function, PBKDF2, specified in RSA PKCS#5 v2.0"
HOMEPAGE="http://www.dlitz.net/software/python-pbkdf2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE=""

python_test() {
	"${PYTHON}" test/test_pbkdf2.py || die "Tests failed with ${EPYTHON}"
}
