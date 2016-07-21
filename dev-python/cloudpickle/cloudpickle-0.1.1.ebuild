# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
inherit eutils distutils-r1

DESCRIPTION="Extended pickling support for Python objects"
HOMEPAGE="https://pypi.python.org/pypi/cloudpickle/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
