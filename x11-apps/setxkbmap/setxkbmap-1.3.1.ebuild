# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="Controls the keyboard layout of a running X server"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
DEPEND="x11-libs/libxkbfile
	x11-libs/libX11"
RDEPEND="${RDEPEND}
	x11-misc/xkeyboard-config"
