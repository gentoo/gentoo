# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xinput/xinput-1.6.1.ebuild,v 1.11 2014/01/26 16:20:08 chithanh Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="Utility to set XInput device parameters"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/libX11-1.3
	x11-libs/libXext
	>=x11-libs/libXi-1.5.99.1
	x11-libs/libXinerama
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	>=x11-proto/inputproto-2.1.99.1"
