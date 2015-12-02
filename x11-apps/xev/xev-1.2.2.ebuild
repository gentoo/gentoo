# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="Print contents of X events"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~x86-winnt"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-proto/xproto"
