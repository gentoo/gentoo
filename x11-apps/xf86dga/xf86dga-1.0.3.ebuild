# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xf86dga/xf86dga-1.0.3.ebuild,v 1.10 2012/05/15 14:22:59 aballier Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="test program for the XFree86-DGA extension"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	>=x11-libs/libXxf86dga-1.1"
DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto"
