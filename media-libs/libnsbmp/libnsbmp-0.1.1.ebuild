# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libnsbmp/libnsbmp-0.1.1.ebuild,v 1.1 2014/11/15 12:05:13 xmw Exp $

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.2
inherit netsurf

DESCRIPTION="decoding library for BMP and ICO image file formats, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libnsbmp/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE=""

RDEPEND=""
DEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-glibc2.20.patch )
