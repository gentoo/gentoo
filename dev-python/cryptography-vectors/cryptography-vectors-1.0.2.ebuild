# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Test vectors for the cryptography package"
HOMEPAGE="https://pypi.python.org/pypi/cryptography-vectors/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S=${WORKDIR}/${MY_P}
