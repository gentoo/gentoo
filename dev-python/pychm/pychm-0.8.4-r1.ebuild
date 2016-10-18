# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings for the chmlib library"
HOMEPAGE="http://gnochm.sourceforge.net/pychm.html"
SRC_URI="mirror://sourceforge/gnochm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="dev-libs/chmlib"
RDEPEND="${DEPEND}"
