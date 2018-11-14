# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Diffs two Python files at the bytecode level"
HOMEPAGE="https://github.com/myint/pydiff"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-fbsd"

python_test() {
	"${PYTHON}" test_pydiff.py || die "Tests failed under ${EPYTHON}"
}
