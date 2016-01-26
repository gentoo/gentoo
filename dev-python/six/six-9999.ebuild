# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1 mercurial

DESCRIPTION="Python 2 and 3 compatibility library"
HOMEPAGE="https://bitbucket.org/gutworth/six https://pypi.python.org/pypi/six"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/gutworth/six"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND="
	doc? ( dev-python/sphinx )
	test? ( >=dev-python/pytest-2.2.0[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C documentation html
}

python_test() {
	py.test -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( documentation/_build/html/ )
	distutils-r1_python_install_all
}
