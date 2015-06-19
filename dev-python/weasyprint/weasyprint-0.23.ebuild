# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/weasyprint/weasyprint-0.23.ebuild,v 1.2 2015/04/08 08:05:02 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Visual rendering engine for HTML and CSS that can export to PDF"
MY_PN="WeasyPrint"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
HOMEPAGE="http://weasyprint.org https://github.com/Kozea/WeasyPrint"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Note: specific subslot of pango since it inlines some of pango headers.
RDEPEND="x11-libs/pango:0/0
	>=media-gfx/cairosvg-1.0.7[${PYTHON_USEDEP}]
	>=dev-python/html5lib-0.999[${PYTHON_USEDEP}]
	dev-python/cffi:=[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.0[${PYTHON_USEDEP}]
	>=dev-python/cairocffi-0.5[${PYTHON_USEDEP}]
	~dev-python/tinycss-0.3[${PYTHON_USEDEP}]
	>=dev-python/cssselect-0.6[${PYTHON_USEDEP}]
	>=dev-python/pyphen-0.8[${PYTHON_USEDEP}]"
# x11-libs/gdk-pixbuf # optional dep
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		media-fonts/ahem )"

S="${WORKDIR}/${MY_P}"

python_test() {
	py.test || die "testsuite failed under ${EPYTHON}"
}
