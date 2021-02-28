# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Lexer and parser for PHP source implemented using PLY"
HOMEPAGE="
	https://github.com/viraptor/phply/
	https://pypi.org/project/phply/"
SRC_URI="
	https://github.com/viraptor/phply/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="dev-python/ply[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

distutils_enable_tests nose

src_prepare() {
	# namespace? seriously?
	sed -i -e '/namespace_packages/d' setup.py || die
	# prevent installing tests, turn phply back into normal package
	mv tests/__init__.py phply/ || die
	distutils-r1_src_prepare
}
