# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Codecs for Iconv Encodings"
HOMEPAGE="http://cjkpython.i18n.org/"
#SRC_URI="mirror://berlios/cjkpython/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ia64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	distutils-r1_src_compile --with-libc
}
