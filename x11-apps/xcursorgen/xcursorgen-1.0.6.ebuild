# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xcursorgen/xcursorgen-1.0.6.ebuild,v 1.11 2015/05/12 07:13:04 vapier Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="create an X cursor file from a collection of PNG images"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXcursor
	media-libs/libpng:0="
DEPEND="${RDEPEND}"
