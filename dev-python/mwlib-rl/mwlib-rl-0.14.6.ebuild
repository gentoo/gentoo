# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Generate pdfs from mediawiki markup"
HOMEPAGE="http://code.pediapress.com/code/ https://pypi.python.org/pypi/mwlib.rl https://github.com/pediapress/mwlib.rl/"
SRC_URI="https://github.com/pediapress/mwlib.rl/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test pdftk"

RDEPEND=">=dev-python/mwlib-0.15.8-r1[${PYTHON_USEDEP}]
	>=dev-python/mwlib-ext-0.12.4-r1[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.4[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	media-fonts/freefont
	|| ( media-gfx/graphicsmagick[imagemagick] media-gfx/imagemagick )
	pdftk? ( app-text/pdftk )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/0.14.3-use-system-fonts.patch" )
DOCS=( example-mwlib.config README.rst )

python_prepare_all() {
	rm -r mwlib/fonts/freefont || die "removing bundled fonts failed"
	distutils-r1_python_prepare_all
}

python_test() {
	py.test  || die "tests failed under ${EPYTHON}"
}

pkg_postinst() {
	elog "If you need extended/non-lating rendering support, please install the"
	elog "corresponding font packages:"
	elog " - media-fonts/libertine-ttf"
	elog " - media-fonts/sil-ezra"
	elog " - media-fonts/farsi-fonts"
	elog " - media-fonts/arphicfonts"
	elog " - media-fonts/unfonts"
	# TODO: need the following packages as well:
	# ttf-indic-fonts ttf-gfs-artemisia  ttf-thai-arundina
}
