# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python wrapper for GNU Privacy Guard"
HOMEPAGE="http://pythonhosted.org/python-gnupg/ https://github.com/vsajip/python-gnupg/"
SRC_URI="https://github.com/vsajip/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-crypt/gnupg"

PATCHES=( "${FILESDIR}"/${PN}-0.3.6-skip-search-keys-tests.patch
		"${FILESDIR}"/${P}-msg-handle.patch )

python_test() {
	# Note; 1 test fails under pypy only
	"${PYTHON}" test_gnupg.py || die "Tests fail with ${EPYTHON}"
}
