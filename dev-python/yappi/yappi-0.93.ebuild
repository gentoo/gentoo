# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_{3,4}})
inherit distutils-r1

DESCRIPTION="Yet Another Python Profiler"
HOMEPAGE="https://bitbucket.org/sumerc/yappi/"
SRC_URI="https://bitbucket.org/sumerc/${PN}/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
