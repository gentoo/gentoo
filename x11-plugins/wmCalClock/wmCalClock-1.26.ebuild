# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="WMaker DockApp: A Calendar clock with antialiased text"
HOMEPAGE="https://www.dockapps.net/wmcalclock"
SRC_URI="https://www.dockapps.net/download/${P//C/c}.tar.xz"

S="${WORKDIR}/${P//C/c}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( {BUGS,CHANGES,HINTS,README,TODO} )
