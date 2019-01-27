# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 ) # python3_{4,5,6} not supported by traits* deps

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Traits-capable windowing framework"
HOMEPAGE="https://github.com/enthought/pyface"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND="
	>=dev-python/traits-4.1[${PYTHON_USEDEP}]
	|| (
		(
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/PyQt5[gui,network,opengl,printsupport,svg,test?,webengine,widgets,${PYTHON_USEDEP}]
		)
		dev-python/wxpython:*[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/traitsui[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)
"

RESTRICT="test"

python_install_all() {
	use examples && EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
