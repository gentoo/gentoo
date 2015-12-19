# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xorg-2

DESCRIPTION="X rendering operation stress test utility"

KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/libXext"
DEPEND="${RDEPEND}"
