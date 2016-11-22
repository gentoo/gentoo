# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python CRC Generator module"
HOMEPAGE="http://crcmod.sourceforge.net/"
SRC_URI="mirror://sourceforge/crcmod/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DOCS=( changelog test/examples.py )

python_test() {
	"${PYTHON}" test/test_crcmod.py || die "Tests fail with ${EPYTHON}"
}
