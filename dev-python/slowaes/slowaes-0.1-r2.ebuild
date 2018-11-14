# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_P=${P}a1
DESCRIPTION="AES implementation in pure Python"
HOMEPAGE="https://code.google.com/p/slowaes/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools"

S=${WORKDIR}/${MY_P}
