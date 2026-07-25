# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

MY_P=MyST-Parser-${PV}
DESCRIPTION="Extended commonmark compliant parser, with bridges to Sphinx"
HOMEPAGE="
	https://github.com/executablebooks/MyST-Parser/
	https://pypi.org/project/myst-parser/
"
SRC_URI="
	https://github.com/executablebooks/MyST-Parser/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/docutils-0.20[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	<dev-python/markdown-it-py-5[${PYTHON_USEDEP}]
	>=dev-python/markdown-it-py-4.2[${PYTHON_USEDEP}]
	<dev-python/mdit-py-plugins-0.7[${PYTHON_USEDEP}]
	>=dev-python/mdit-py-plugins-0.6.1[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	<dev-python/sphinx-10[${PYTHON_USEDEP}]
	>=dev-python/sphinx-8[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/defusedxml[${PYTHON_USEDEP}]
		<dev-python/linkify-it-py-3[${PYTHON_USEDEP}]
		>=dev-python/linkify-it-py-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.3[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{datadir,param-files,regressions} sphinx-pytest )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# docutils warning
	'tests/test_renderers/test_fixtures_docutils.py::test_link_resolution[121-explicit>implicit]'
)

src_prepare() {
	default

	# unpin docutils
	sed -i -e '/docutils/s:,<[0-9.]*::' pyproject.toml || die
}
