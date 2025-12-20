# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for back-end component for the GNUstep GUI Library"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"

RDEPEND="|| (
		~gnustep-base/gnustep-back-cairo-${PV}
		~gnustep-base/gnustep-back-art-${PV}
		~gnustep-base/gnustep-back-xlib-${PV}
	)"
