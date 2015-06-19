# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/progressbar/progressbar-2.3-r1.ebuild,v 1.11 2015/04/08 08:05:09 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="http://code.google.com/p/python-progressbar/ http://pypi.python.org/pypi/progressbar"
SRC_URI="http://python-${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

PATCHES=( "${FILESDIR}/progressbar-2.3-python3.3.patch" )
