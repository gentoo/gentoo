# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Testing support by jaraco"
HOMEPAGE="
	https://github.com/jaraco/jaraco.test/
	https://pypi.org/project/jaraco.test/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/.}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"

RDEPEND="
	dev-python/jaraco-collections[${PYTHON_USEDEP}]
	dev-python/jaraco-context[${PYTHON_USEDEP}]
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# stray dep
	sed -i -e '/toml/d' setup.cfg || die
	distutils-r1_src_prepare
}
