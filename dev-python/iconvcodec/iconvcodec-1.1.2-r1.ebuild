# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/iconvcodec/iconvcodec-1.1.2-r1.ebuild,v 1.5 2015/04/14 12:49:51 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Codecs for Iconv Encodings"
HOMEPAGE="http://cjkpython.i18n.org/"
SRC_URI="mirror://berlios/cjkpython/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ia64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	distutils-r1_src_compile --with-libc
}
