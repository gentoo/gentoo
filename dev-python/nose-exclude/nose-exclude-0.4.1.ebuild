# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1

DESCRIPTION="Exclude specific directories from nosetests runs"
HOMEPAGE="https://github.com/kgrandis/nose-exclude"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ppc64 ~sparc x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/nose[${PYTHON_USEDEP}]"

python_test() {
	# https://github.com/kgrandis/nose-exclude/issue/10/test-failures-with-python-3
	python_is_python3 && return
	esetup.py test
}
