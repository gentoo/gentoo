# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MODULE=data/
inherit xorg-3

DESCRIPTION="X.Org cursor themes: whiteglass, redglass and handhelds"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"

BDEPEND="
	x11-apps/xcursorgen
"
RDEPEND="
	x11-libs/libX11
	x11-libs/libXcursor
"
