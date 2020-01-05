# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Generate block-diagram image from text"
HOMEPAGE="http://blockdiag.com/ https://pypi.org/project/blockdiag/ https://bitbucket.org/blockdiag/blockdiag/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/funcparserlib-0.3.6[${PYTHON_USEDEP}]
	>=dev-python/pillow-2.2.1[${PYTHON_USEDEP}]
	dev-python/webcolors[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/configparser[${PYTHON_USEDEP}]' -2)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		media-fonts/ja-ipafonts
	)
"

PATCHES=( "${FILESDIR}/blockdiag-1.5.3-py2_7-test-fix.patch")
python_prepare_all() {
	sed -i -e /build-base/d setup.cfg || die
	# unnecessary dep
	sed -i -e '/pep8/d' setup.py || die
	# disable tests requiring Internet access
	sed -i -e 's:test_app_cleans_up_images:_&:' \
		src/blockdiag/tests/test_command.py || die
	sed -i -e 's:ghostscript_not_found_test:_&:' \
		src/blockdiag/tests/test_generate_diagram.py || die
	rm src/blockdiag/tests/diagrams/node_icon.diag || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

pkg_postinst() {
	einfo "For additional functionality, install the following optional packages:"
	einfo "    dev-python/reportlab for pdf format"
	einfo "    media-gfx/imagemagick"
	einfo "    wand: https://pypi.org/project/Wand"
	einfo "          Ctypes-based simple MagickWand API binding for Python"
}
