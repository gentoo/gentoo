# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Note: greenlet is built-in in pypy
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Lightweight in-process concurrent programming"
HOMEPAGE="https://pypi.org/project/greenlet/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 -hppa -ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

distutils_enable_sphinx doc --no-autodoc

python_test() {
	"${EPYTHON}" -m unittest discover -v greenlet.tests ||
		die "Tests failed with ${EPYTHON}"
}
