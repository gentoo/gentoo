# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXTrap/libXTrap-1.0.0-r1.ebuild,v 1.10 2013/08/20 17:00:05 hasufell Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org XTrap library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-proto/trapproto
	x11-proto/xextproto"
DEPEND="${RDEPEND}"
