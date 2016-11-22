# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="A library to bring functools.singledispatch from Python 3.4 to Python 2.6-3.3"
HOMEPAGE="http://docs.python.org/3/library/functools.html#functools.singledispatch"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sparc x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
