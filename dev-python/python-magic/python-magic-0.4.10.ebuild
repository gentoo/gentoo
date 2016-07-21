# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Access the libmagic file type identification library"
HOMEPAGE="https://github.com/ahupp/python-magic"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 hppa ia64 x86"
IUSE=""

RDEPEND="sys-apps/file[-python]"
DEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# https://github.com/ahupp/python-magic/issues/97
RESTRICT="test"

python_test() {
	esetup.py test
}
