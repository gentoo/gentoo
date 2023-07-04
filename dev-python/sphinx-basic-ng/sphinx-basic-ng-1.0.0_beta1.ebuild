# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

MY_P=${P/_/.}
DESCRIPTION="A modern skeleton for Sphinx themes"
HOMEPAGE="
	https://github.com/pradyunsg/sphinx-basic-ng/
	https://pypi.org/project/sphinx-basic-ng/
"
SRC_URI="
	https://github.com/pradyunsg/sphinx-basic-ng/archive/${PV/_/.}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/sphinx-4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/myst-parser[${PYTHON_USEDEP}]
	)
"

python_test() {
	local HTML_DOCS=()
	build_sphinx tests/barebones
	rm -r tests/barebones/_build || die
}
