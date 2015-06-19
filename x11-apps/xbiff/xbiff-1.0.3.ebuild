# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xbiff/xbiff-1.0.3.ebuild,v 1.7 2011/03/05 18:00:51 xarthisius Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="mailbox flag for X"

KEYWORDS="amd64 arm hppa ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libX11
	x11-misc/xbitmaps
	x11-libs/libXext"
DEPEND="${RDEPEND}"
