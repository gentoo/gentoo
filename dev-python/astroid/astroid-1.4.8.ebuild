# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="https://bitbucket.org/logilab/astroid https://pypi.python.org/pypi/astroid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x86-macos"
IUSE="test"

# still broken
RESTRICT=test

# Version specified in __pkginfo__.py.
RDEPEND="
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]"
DEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"
#	test? (
#		${RDEPEND}
#		>=dev-python/pylint-1.4.0[${PYTHON_USEDEP}]
#		dev-python/pytest[${PYTHON_USEDEP}]
#		$(python_gen_cond_dep 'dev-python/egenix-mx-base[${PYTHON_USEDEP}]' python2_7)
#	)"
# Required for tests
DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	${EPYTHON} -m unittest discover -p "unittest*.py" --verbose || die
}
