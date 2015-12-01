# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4,3_5})

inherit distutils-r1
MY_PN=zope.component
MY_P=${MY_PN}-${PV}

DESCRIPTION="Zope Component Architecture"
HOMEPAGE="https://github.com/zopefoundation/zope.component http://docs.zope.org/zope.component/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RDEPEND="dev-python/zope-event[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-4.1.0[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND}
	dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

RESTRICT="test"

python_test() {
	nosetests || die
}
