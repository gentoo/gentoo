# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/root_numpy/root_numpy-3.3.1.ebuild,v 1.2 2015/04/08 08:05:15 mgorny Exp $

EAPI=5

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Interface between ROOT and numpy"
HOMEPAGE="https://github.com/rootpy/root_numpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-physics/root[python,${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	cd "${BUILD_DIR}" || die
	nosetests -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( tutorial/. )
	distutils-r1_python_install_all
}
