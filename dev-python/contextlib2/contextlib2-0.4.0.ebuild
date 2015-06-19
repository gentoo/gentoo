# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/contextlib2/contextlib2-0.4.0.ebuild,v 1.8 2015/04/08 08:05:26 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Backports and enhancements for the contextlib module"
HOMEPAGE="https://pypi.python.org/pypi/contextlib2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2.4"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

python_test() {
	"${PYTHON}" test_contextlib2.py || die "Tests fail for ${EPYTHON}"
}
