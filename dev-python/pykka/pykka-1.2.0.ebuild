# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pykka/pykka-1.2.0.ebuild,v 1.2 2015/07/05 11:02:00 mrueg Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_3,3_4})

inherit distutils-r1

DESCRIPTION="A Python implementation of the actor model"
HOMEPAGE="http://pykka.org https://github.com/jodal/pykka"
SRC_URI="mirror://pypi/P/Pykka/Pykka-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/Pykka-${PV}

python_test() {
	nosetests || die
}
