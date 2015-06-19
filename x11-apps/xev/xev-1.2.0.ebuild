# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xev/xev-1.2.0.ebuild,v 1.11 2012/08/26 16:41:42 armin76 Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="print contents of X events"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~x86-winnt"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-proto/xproto"
