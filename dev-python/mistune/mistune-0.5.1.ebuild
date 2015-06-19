# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mistune/mistune-0.5.1.ebuild,v 1.1 2015/04/15 08:45:46 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="The fastest markdown parser in pure Python"
HOMEPAGE="https://pypi.python.org/pypi/mistune https://github.com/lepture/mistune"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/cython[$(python_gen_usedep 'python*')]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	nosetests || die
}
