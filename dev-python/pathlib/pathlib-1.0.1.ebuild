# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pathlib/pathlib-1.0.1.ebuild,v 1.5 2015/06/12 08:17:17 idella4 Exp $

EAPI=5

# In Python 3.4, pathlib is now part of the standard library.
PYTHON_COMPAT=( python{2_7,3_3} pypy )
inherit distutils-r1

DESCRIPTION="Object-oriented filesystem paths"
HOMEPAGE="https://pathlib.readthedocs.org/"
SRC_URI="mirror://pypi/p/pathlib/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
