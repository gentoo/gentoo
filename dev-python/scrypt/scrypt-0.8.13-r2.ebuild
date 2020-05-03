# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

DESCRIPTION="Bindings for the scrypt key derivation function library"
HOMEPAGE="https://bitbucket.org/mhallin/py-scrypt/wiki/Home/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="test doc"

RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
