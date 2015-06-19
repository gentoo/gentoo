# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyamg/pyamg-2.1.0.ebuild,v 1.3 2015/05/17 15:33:40 mrueg Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Algebraic multigrid solvers in Python"
HOMEPAGE="http://pyamg.github.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_test() {
	distutils_install_for_testing
	cd "${T}" || die # need to be away source directory
	${EPYTHON} -c "
import pyamg, sys
r = pyamg.test(verbose=3)
sys.exit(0 if r.wasSuccessful() else 1)" || die "Tests fail with ${EPYTHON}"
}
