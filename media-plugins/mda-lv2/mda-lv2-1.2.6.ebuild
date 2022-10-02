# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

DESCRIPTION="LV2 port of the MDA plugins by Paul Kellett"
HOMEPAGE="https://drobilla.net/software/mda-lv2.html"
SRC_URI="https://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="media-libs/lv2"
DEPEND="
	${PYTHON_DEPS}
"
