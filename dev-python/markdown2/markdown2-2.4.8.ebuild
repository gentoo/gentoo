# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python Markdown language reimplementation"
HOMEPAGE="
	https://github.com/trentm/python-markdown2/
	https://pypi.org/project/markdown2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/pygments-2.7.3[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	cd test || die
	"${EPYTHON}" -m unittest test_markdown2.py -v ||
		die "Tests fail with ${EPYTHON}"
}
