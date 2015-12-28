# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{3,4} )
inherit distutils-r1

DESCRIPTION="Minuit numerical function minimization in Python"
HOMEPAGE="https://github.com/iminuit/iminuit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SLOT="0"
LICENSE="MIT LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-python/cython"
RDEPEND="${DEPEND}"
