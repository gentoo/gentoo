# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 virtualx

DESCRIPTION="CFFI-based drop-in replacement for Pycairo"
HOMEPAGE="https://github.com/Kozea/cairocffi"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]
	' 'python*')
	>=dev-python/xcffib-0.3.2[${PYTHON_USEDEP}]
	x11-libs/cairo:0=[X,xcb(+)]
	x11-libs/gdk-pixbuf[jpeg]"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-tests.patch
	"${FILESDIR}"/${PN}-1.0.2-test-deps.patch
)

python_test() {
	virtx pytest -vv --pyargs cairocffi
}
