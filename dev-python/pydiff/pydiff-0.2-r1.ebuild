# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Diffs two Python files at the bytecode level"
HOMEPAGE="https://github.com/myint/pydiff"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ia64 ~ppc ~sparc x86"

python_test() {
	"${EPYTHON}" test_pydiff.py || die "Tests failed under ${EPYTHON}"
}
