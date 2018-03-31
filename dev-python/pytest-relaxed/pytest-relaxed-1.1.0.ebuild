# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="py.test plugin for relaxed test discovery and organization"
HOMEPAGE="https://pypi.python.org/pypi/pytest-relaxed https://github.com/bitprophet/pytest-relaxed"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~amd64-fbsd ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris"
IUSE="test"

RDEPEND="
	>=dev-python/pytest-3[${PYTHON_USEDEP}]
	>=dev-python/six-1[${PYTHON_USEDEP}]
	>=dev-python/decorator-4[${PYTHON_USEDEP}]
"
DEPEND="test? ( ${RDEPEND} )"

# various misc failures
RESTRICT="test"

python_test() {
	py.test || die "tests failed with ${EPYTHON}"
}
