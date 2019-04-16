# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

DESCRIPTION="LV2 port of the MDA plugins by Paul Kellett"
HOMEPAGE="http://drobilla.net/software/mda-lv2/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-libs/lv2"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( "README" )
