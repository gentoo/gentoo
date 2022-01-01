# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_MODULE=data/
inherit xorg-2

DESCRIPTION="X.Org cursor themes: whiteglass, redglass and handhelds"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXcursor
"
DEPEND="${RDEPEND}
	x11-apps/xcursorgen"
