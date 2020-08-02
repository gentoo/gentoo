# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1 virtualx

MY_PN="${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CFFI-based drop-in replacement for Pycairo"
HOMEPAGE="https://github.com/Kozea/cairocffi"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]' 'python*')
	>=dev-python/xcffib-0.3.2[${PYTHON_USEDEP}]
	x11-libs/cairo:0=[X,xcb(+)]
	x11-libs/gdk-pixbuf[jpeg]"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

S="${WORKDIR}/${MY_P}"

distutils_enable_sphinx docs

python_test() {
	virtx py.test -v --pyargs cairocffi
}
