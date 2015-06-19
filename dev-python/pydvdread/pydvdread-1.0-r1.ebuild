# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pydvdread/pydvdread-1.0-r1.ebuild,v 1.2 2015/01/01 23:13:51 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="A set of Python bindings for the libdvdread library"
HOMEPAGE="http://pydvdread.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""
RESTRICT="test" # Requires an actual DVD to test.

DEPEND="media-libs/libdvdread
		dev-lang/swig"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-py3k.patch \
		"${FILESDIR}"/${P}-api-update.patch )

python_test() {
	"${PYTHON}" tests/TestAll.py || die "Tests fail with ${EPYTHON}"
}
