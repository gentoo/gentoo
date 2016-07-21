# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{3,4}} )

inherit distutils-r1

DESCRIPTION="Set of extensions to Ian Bicking's virtualenv tool"
HOMEPAGE="
	http://www.doughellmann.com/projects/virtualenvwrapper
	https://pypi.python.org/pypi/virtualenvwrapper"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# testsuite doesn't work out of the box.  Demand of a virtualenv outstrips setup by the eclass
RESTRICT=test

RDEPEND="
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=dev-python/stevedore-0.15-r1[${PYTHON_USEDEP}]
	dev-python/virtualenv-clone[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]"

# Keep just in case
src_prepare() {
	sed -e 's:-o shwordsplit::' -i tests/run_tests || die
}

python_test() {
	bash ./tests/run_tests || die "Tests failed under ${EPYTHON}"
}
