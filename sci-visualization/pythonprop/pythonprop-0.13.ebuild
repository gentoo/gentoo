# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Scripts to prepare and plot VOACAP propagation predictions"
HOMEPAGE="http://www.qsl.net/hz1jw/pythonprop"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/matplotlib[gtk2,${PYTHON_USEDEP}]
	dev-python/basemap[${PYTHON_USEDEP}]
	sci-electronics/voacapl
"
DEPEND="${RDEPEND}"
