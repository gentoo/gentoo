# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Meta package for the Enthought Tool Suite"
HOMEPAGE="http://code.enthought.com/projects/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

# see the setup_data.py file for version numbers
RDEPEND="
	>=dev-python/apptools-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/blockcanvas-4.0.3[${PYTHON_USEDEP}]
	>=dev-python/casuarius-1.1[${PYTHON_USEDEP}]
	>=dev-python/chaco-4.4.1[${PYTHON_USEDEP}]
	>=dev-python/codetools-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/enable-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/enaml-0.6.8[${PYTHON_USEDEP}]
	>=dev-python/encore-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/envisage-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/etsdevtools-4.0.2[${PYTHON_USEDEP}]
	>=dev-python/etsproxy-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/graphcanvas-4.0.2[${PYTHON_USEDEP}]
	>=sci-visualization/mayavi-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyface-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/scimath-4.1.2[${PYTHON_USEDEP}]
	>=dev-python/traits-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/traitsui-4.4.0[${PYTHON_USEDEP}]"

DEPEND=""
