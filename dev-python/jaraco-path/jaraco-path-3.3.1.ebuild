# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

MY_P="${P/-/.}"
DESCRIPTION="Miscellaneous path functions"
HOMEPAGE="https://github.com/jaraco/jaraco.path/"
SRC_URI="mirror://pypi/${PN::1}/${PN/-/.}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	">=dev-python/jaraco-packaging-8.2" \
	">=dev-python/rst-linker-1.9"
distutils_enable_tests pytest

src_prepare() {
	# use the py3.7+ built-in
	sed -i -e '/singledispatch/d' setup.cfg || die
	sed -i -e 's:from singledispatch:from functools:' jaraco/path.py || die

	distutils-r1_src_prepare
}

python_test() {
	pytest -vv tests || die "Tests failed with ${EPYTHON}"
}
