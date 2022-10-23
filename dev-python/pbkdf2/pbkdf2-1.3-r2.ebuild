# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Implementation of PBKDF2, specified in RSA PKCS#5 v2.0"
HOMEPAGE="https://www.dlitz.net/software/python-pbkdf2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux"

python_test() {
	"${EPYTHON}" test/test_pbkdf2.py -v || die "Tests failed with ${EPYTHON}"
}
