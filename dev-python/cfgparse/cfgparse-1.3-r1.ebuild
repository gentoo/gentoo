# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Config File parser for Python"
HOMEPAGE="http://cfgparse.sourceforge.net https://pypi.python.org/pypi/cfgparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="PSF-2.3"
SLOT="0"
KEYWORDS="amd64 ia64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="README.txt docs/cfgparse.pdf"
