# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3)

inherit distutils-r1

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="https://code.google.com/p/python-progressbar/ https://pypi.python.org/pypi/progressbar"
SRC_URI="https://python-${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

PATCHES=( "${FILESDIR}/progressbar-2.3-python3.3.patch" )
