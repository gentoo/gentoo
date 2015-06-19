# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dingus/dingus-0.3.4-r1.ebuild,v 1.6 2015/04/08 08:05:03 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="A record-then-assert mocking library"
HOMEPAGE="http://pypi.python.org/pypi/dingus/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_prepare_all() {
	sed -i -e '/data_files/d' setup.py || die #413769
	distutils-r1_python_prepare_all
}
