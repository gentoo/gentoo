# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.5
inherit netsurf

DESCRIPTION="decoding library for BMP and ICO image file formats, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~m68k-mint"
IUSE=""

RDEPEND=""
DEPEND="virtual/pkgconfig"
