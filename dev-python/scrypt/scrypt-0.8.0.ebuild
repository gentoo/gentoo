# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Bindings for the scrypt key derivation function library"
HOMEPAGE="https://bitbucket.org/mhallin/py-scrypt/wiki/Home/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="amd64 ~arm ~arm64 x86"
SLOT="0"
IUSE="test doc"

RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# dist tarball does not have tests
RESTRICT=test

python_test() {
	esetup.py test
}
