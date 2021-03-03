# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_PN="WeasyPrint"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Visual rendering engine for HTML and CSS that can export to PDF"
HOMEPAGE="https://weasyprint.org https://github.com/Kozea/WeasyPrint"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg tiff"

# Note: specific subslot of pango since it inlines some of pango headers.
#	>=dev-python/lxml-3.0[${PYTHON_USEDEP}]
RDEPEND="
	>=dev-python/cairocffi-0.9[${PYTHON_USEDEP}]
	>=dev-python/cffi-0.6:=[${PYTHON_USEDEP}]
	>=dev-python/cssselect2-0.1[${PYTHON_USEDEP}]
	>=dev-python/html5lib-0.999999999[${PYTHON_USEDEP}]
	>=dev-python/pyphen-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/tinycss2-1.0.0[${PYTHON_USEDEP}]
	>=media-gfx/cairosvg-2.4.0[${PYTHON_USEDEP}]
	>=x11-libs/cairo-1.15.4
	x11-libs/gdk-pixbuf[jpeg?,tiff?]
	x11-libs/pango:0/0
"

BDEPEND="
	test? (
		media-fonts/ahem
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/pytest-runner/d' \
		-e 's:--flake8 --isort::' \
		-i setup.cfg || die
	distutils-r1_src_prepare
}
