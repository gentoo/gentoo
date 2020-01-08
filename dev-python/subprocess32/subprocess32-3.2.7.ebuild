# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A backport of the subprocess module from Python 3.2/3.3 for use on 2.x"
HOMEPAGE="https://github.com/google/python-subprocess32"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${P}-sandbox-test-fix.patch )

python_test() {
	"${PYTHON}" test_subprocess32.py || die "Tests fail with ${EPYTHON}"
}
