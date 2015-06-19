# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/viewres/viewres-1.0.4.ebuild,v 1.8 2013/10/08 05:03:06 ago Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="graphical class browser for Xt"

KEYWORDS="amd64 arm hppa ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="x11-libs/libXaw
	x11-libs/libXt
	x11-libs/libXmu"
DEPEND="${RDEPEND}"
