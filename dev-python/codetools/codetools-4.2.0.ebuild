# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Code analysis and execution tools"
HOMEPAGE="http://code.enthought.com/projects/code_tools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

IUSE="test"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/scimath-4[${PYTHON_USEDEP}]
	>=dev-python/traits-4[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/blockcanvas[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		virtual/python-futures[${PYTHON_USEDEP}]
	)"

python_test() {
	VIRTUALX_COMMAND="nosetests" virtualmake -e with_mask_test_case
}
