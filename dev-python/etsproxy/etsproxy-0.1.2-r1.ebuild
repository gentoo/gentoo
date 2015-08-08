# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Enthought Tool Suite: Proxy modules for backwards compatibility"
HOMEPAGE="http://pypi.python.org/pypi/etsproxy"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="!<dev-python/apptools-4
	!<dev-python/blockcanvas-4
	!<dev-python/chaco-4
	!<dev-python/codetools-4
	!<dev-python/enable-4
	!<dev-python/enthoughtbase-4
	!<dev-python/envisagecore-4
	!<dev-python/envisageplugins-4
	!<dev-python/etsdevtools-4
	!<dev-python/etsprojecttools-4
	!<dev-python/graphcanvas-4
	!<sci-visualization/mayavi-4
	!<dev-python/scimath-4
	!<dev-python/traits-4
	!<dev-python/traitsbackendwx-4
	!<dev-python/traitsbackendqt-4
	!<dev-python/traitsgui-4"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
