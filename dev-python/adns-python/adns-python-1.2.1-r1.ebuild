# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings for ADNS"
HOMEPAGE="https://code.google.com/p/adns-python/ https://pypi.python.org/pypi/adns-python"
SRC_URI="https://adns-python.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=net-libs/adns-1.3"
RDEPEND="${DEPEND}"
