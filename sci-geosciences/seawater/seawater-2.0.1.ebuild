# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/seawater/seawater-2.0.1.ebuild,v 1.5 2015/04/08 18:49:16 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Python version of the SEAWATER 3.2 MATLAB toolkit for calculating the properties of sea water"
HOMEPAGE="http://pypi.python.org/pypi/seawater/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

DOCS=( "${S}"/docs/. )
