# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xcursorgen/xcursorgen-1.0.5.ebuild,v 1.9 2012/08/26 16:39:54 armin76 Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="create an X cursor file from a collection of PNG images"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXcursor
	media-libs/libpng:0"
DEPEND="${RDEPEND}"
