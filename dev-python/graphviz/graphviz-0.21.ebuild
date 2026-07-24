# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Simple Python interface for Graphviz"
HOMEPAGE="
	https://graphviz.readthedocs.io/
	https://github.com/xflr6/graphviz/
	https://pypi.org/project/graphviz/
"
SRC_URI="
	https://github.com/xflr6/graphviz/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	media-gfx/graphviz
"
BDEPEND="
	test? (
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		media-gfx/graphviz[gts,pdf]
	)
"

PATCHES=( "${FILESDIR}/${P}_fix_python3_14_tests.patch" )

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e '/--cov/d' pyproject.toml || die
}

EPYTEST_IGNORE=(
	# workaround https://github.com/pytest-dev/pytest/issues/12123
	tests/backend/conftest.py
	tests/conftest.py
)
