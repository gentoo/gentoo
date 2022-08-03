# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_P=${P/_alpha/.a}
DESCRIPTION="A modern skeleton for Sphinx themes"
HOMEPAGE="
	https://github.com/pradyunsg/sphinx-basic-ng/
	https://pypi.org/project/sphinx-basic-ng/
"
SRC_URI="
	https://github.com/pradyunsg/sphinx-basic-ng/archive/${PV/_alpha/.a}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/sphinx-6[${PYTHON_USEDEP}]
	>=dev-python/sphinx-4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/myst_parser[${PYTHON_USEDEP}]
	)
"

python_test() {
	local HTML_DOCS=()
	build_sphinx tests/barebones
	rm -r tests/barebones/_build || die
}
