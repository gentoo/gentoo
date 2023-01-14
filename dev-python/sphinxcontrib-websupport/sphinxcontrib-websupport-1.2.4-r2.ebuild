# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Sphinx websupport extension"
HOMEPAGE="
	https://www.sphinx-doc.org/
	https://github.com/sphinx-doc/sphinxcontrib-websupport/
	https://pypi.org/project/sphinxcontrib-websupport/
"
# pypi tarball is missing templates
SRC_URI="
	https://github.com/sphinx-doc/sphinxcontrib-websupport/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"

RDEPEND="
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-serializinghtml[${PYTHON_USEDEP}]
"
# avoid circular dependency with sphinx
PDEPEND="
	>=dev-python/sphinx-1.5.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${PDEPEND}
		>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
		>=dev-python/whoosh-2.0[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	# breaks tests
	sed -i -e '/pkg_resources/d' \
		sphinxcontrib/websupport/__init__.py || die
	# strip the .dev tag from version number
	sed -i -e '/tag/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	distutils_write_namespace sphinxcontrib
	cd "${T}" || die
	epytest "${S}"/tests
}
