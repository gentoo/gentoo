# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="dump an image of an X window"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

# libXt dependency is not in configure.ac, bug #408629, upstream #47462."
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXt
	x11-libs/libxkbfile
	x11-proto/xproto"
