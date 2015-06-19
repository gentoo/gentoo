# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/weasyprint/weasyprint-0.21-r1.ebuild,v 1.2 2015/04/08 08:05:02 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Visual rendering engine for HTML and CSS that can export to PDF"
MY_PN="WeasyPrint"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
HOMEPAGE="http://weasyprint.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Note: specific subslot of pango since it inlines some of pango headers.
RDEPEND="x11-libs/pango:0/0
	media-gfx/cairosvg
	dev-python/cffi:=[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/cairocffi[${PYTHON_USEDEP}]
	dev-python/tinycss[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/pyphen[${PYTHON_USEDEP}]
	"
	# x11-libs/gdk-pixbuf # optional dep
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
