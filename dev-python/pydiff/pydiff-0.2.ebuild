# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pydiff/pydiff-0.2.ebuild,v 1.1 2014/12/23 06:08:00 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Diffs two Python files at the bytecode level"
HOMEPAGE="https://github.com/myint/pydiff"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_test() {
	"${PYTHON}" test_pydiff.py || die "Tests failed under ${EPYTHON}"
}
