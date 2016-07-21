# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="interchange between cut buffer and selection"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""
RDEPEND="x11-libs/libXaw
	x11-libs/libxkbfile
	x11-libs/libXmu
	>=x11-libs/libXt-1.1
	x11-libs/libX11"
DEPEND="${RDEPEND}"
