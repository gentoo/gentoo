# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="a dockapp that displays time and date (same style as NEXTSTEP(tm) OS)"
HOMEPAGE="https://www.dockapps.net/wmclock"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

# Specific path for this version
S="${WORKDIR}/dockapps-daaf3aa"

src_prepare() {
	default
	eautoreconf
}
