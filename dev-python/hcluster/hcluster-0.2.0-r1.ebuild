# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python hierarchical clustering package for Scipy"
HOMEPAGE="https://code.google.com/p/scipy-cluster/ https://pypi.python.org/pypi/hcluster"
SRC_URI="https://scipy-cluster.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/matplotlib[${PYTHON_USEDEP}]"

# Tests need X display with matplotlib.
RESTRICT="test"
