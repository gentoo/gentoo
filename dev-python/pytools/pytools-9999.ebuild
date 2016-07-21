# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
EGIT_MIN_CLONE_TYPE=single

inherit distutils-r1 git-r3

DESCRIPTION="A collection of tools missing from the Python standard library"
HOMEPAGE="http://mathema.tician.de/software/pytools"
EGIT_REPO_URI="http://git.tiker.net/trees/pytools.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	>=dev-python/setuptools-0.7.2[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND=""

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}
