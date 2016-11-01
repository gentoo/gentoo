# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A low-level ctypes wrapper for Ed25519 digital signatures."
HOMEPAGE="http://bitbucket.org/dholth/ed25519ll/ http://pypi.python.org/pypi/ed25519ll"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"

# https://bitbucket.org/dholth/ed25519ll/issues/1/testfailures-with-python-3
RESTRICT=test

python_test() {
	esetup.py test
}
