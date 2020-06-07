# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python Markdown language reimplementation"
SRC_URI="mirror://pypi/m/markdown2/${P}.tar.gz"
HOMEPAGE="https://github.com/trentm/python-markdown2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

src_test() {
	cd test || die
	distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" -m unittest test_markdown2.py -v ||
		die "Tests fail with ${EPYTHON}"
}
