# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/xlsxwriter/xlsxwriter-0.7.3.ebuild,v 1.1 2015/05/27 16:25:28 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

MY_PN="XlsxWriter"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python module for creating Excel XLSX files"
HOMEPAGE="https://pypi.python.org/pypi/XlsxWriter https://github.com/jmcnamara/XlsxWriter"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

S="${WORKDIR}"/${MY_P}

python_test() {
	nosetests --verbosity=3 || die
}
