# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 virtualx

DESCRIPTION="CFFI-based drop-in replacement for Pycairo"
HOMEPAGE="
	https://github.com/Kozea/cairocffi/
	https://pypi.org/project/cairocffi/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]
	' 'python*')
	>=dev-python/xcffib-0.3.2[${PYTHON_USEDEP}]
	x11-libs/cairo:0=[X,xcb(+)]
	x11-libs/gdk-pixbuf[jpeg]
"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pikepdf[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-tests.patch
)

src_test() {
	rm -r cairocffi || die
	virtx distutils-r1_src_test
}
