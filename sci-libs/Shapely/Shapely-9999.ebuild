# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/Shapely/Shapely-9999.ebuild,v 1.3 2015/01/08 12:53:15 jlec Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 git-r3

DESCRIPTION="Geometric objects, predicates, and operations"
HOMEPAGE="https://pypi.python.org/pypi/Shapely"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Toblerity/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND=">=sci-libs/geos-3.1"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
