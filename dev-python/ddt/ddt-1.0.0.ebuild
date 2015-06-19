# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ddt/ddt-1.0.0.ebuild,v 1.1 2015/04/28 20:18:36 prometheanfire Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="A library to multiply test cases"
HOMEPAGE="http://pypi.python.org/pypi/ddt https://github.com/txels/ddt"
SRC_URI="mirror://pypi/d/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
