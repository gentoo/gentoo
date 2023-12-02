# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Draws Python object reference graphs with graphviz"
HOMEPAGE="
	https://github.com/mgedmin/objgraph/
	https://pypi.org/project/objgraph/
"

LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="doc"

RDEPEND="
	media-gfx/graphviz
"
BDEPEND="
	test? (
		media-gfx/xdot
	)
"

PATCHES=(
	"${FILESDIR}/objgraph-3.4.1-tests.patch"
)

distutils_enable_tests unittest

src_prepare() {
	# the dependency is optional, actually
	sed -i -e '/graphviz/d' setup.py || die
	distutils-r1_src_prepare
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/* )
	distutils-r1_python_install_all
}
