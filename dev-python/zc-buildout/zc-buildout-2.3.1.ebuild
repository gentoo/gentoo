# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/zc-buildout/zc-buildout-2.3.1.ebuild,v 1.1 2014/12/31 06:08:16 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="System for managing development buildouts"
HOMEPAGE="http://pypi.python.org/pypi/zc.buildout"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/setuptools-3.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

DOCS=( README.rst doc/tutorial.txt )
# Tests require zope packages absent from portage

# Prevent incorrect installation of data file
python_prepare_all() {
	sed -e '/^    include_package_data/d' -i setup.py || die
	distutils-r1_python_prepare_all
}
