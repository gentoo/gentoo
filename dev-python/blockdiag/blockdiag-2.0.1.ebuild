# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1 optfeature

DESCRIPTION="Generate block-diagram image from text"
HOMEPAGE="http://blockdiag.com/ https://pypi.org/project/blockdiag/ https://github.com/blockdiag/blockdiag/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/funcparserlib-0.3.6[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.0.0[${PYTHON_USEDEP}]
	dev-python/webcolors[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		media-fonts/ja-ipafonts
	)
"

distutils_enable_tests setup.py

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

pkg_postinst() {
	# TODO: Better descriptions!
	einfo "For additional functionality, install the following optional packages:"
	optfeature "for PDF format" dev-python/reportlab
	optfeature "misc extra support" media-gfx/imagemagick
	optfeature "Ctypes-based simple MagickWand API binding for Python" dev-python/wand
}
