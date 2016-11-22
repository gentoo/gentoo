# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=xdot.py
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Interactive viewer for Graphviz dot files"
HOMEPAGE="https://github.com/jrfonseca/xdot.py"
SRC_URI="https://github.com/jrfonseca/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.10:2[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-gfx/graphviz[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
