# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Converting Jupyter Notebooks"
HOMEPAGE="https://nbconvert.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	>=dev-python/entrypoints-0.2.2[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	>=dev-python/mistune-0.7.4[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/pandocfilters-1.4.1[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
	dev-python/testpath[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pebble[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		>=dev-python/jupyter_client-4.2[${PYTHON_USEDEP}]
		media-gfx/inkscape
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-inkscape-1.patch
	"${FILESDIR}"/${P}-py39.patch
)

src_prepare() {
	# assumes old inkscape output?
	sed -i -e '/SVG\.ipynb/d' \
		nbconvert/preprocessors/tests/test_execute.py || die

	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing bdist_egg
	cd "${TEST_DIR}"/lib || die
	pytest -vv --pyargs nbconvert || die
}

pkg_postinst() {
	if ! has_version app-text/pandoc ; then
		einfo "Pandoc is required for converting to formats other than Python,"
		einfo "HTML, and Markdown. If you need this functionality, install"
		einfo "app-text/pandoc."
	fi
}
