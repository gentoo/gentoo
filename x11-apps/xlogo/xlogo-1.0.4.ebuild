# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xlogo/xlogo-1.0.4.ebuild,v 1.8 2012/08/26 16:58:27 armin76 Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="X Window System logo"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-interix"
IUSE=""

RDEPEND="x11-libs/libXrender
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXaw
	x11-libs/libSM
	x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="--with-render"
