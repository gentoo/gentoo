# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Module providing raw yEnc encoding/decoding"
HOMEPAGE="http://www.golug.it/yenc.html"
SRC_URI="http://www.golug.it/pub/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Remove forced CFLAG on setup.py
PATCHES=( "${FILESDIR}"/${PN}-remove-cflags.patch )
DOCS=( README TODO CHANGES doc/${PN}-draft.1.3.txt )

python_test() {
	"${PYTHON}" test/test.py || die "Test failed."
}

src_test() {
	# Tests use a constant temp file.
	DISTUTILS_NO_PARALLEL_BUILD=1 distutils-r1_src_test
}
