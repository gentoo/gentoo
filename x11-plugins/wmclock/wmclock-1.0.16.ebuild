# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools

DESCRIPTION="a dockapp that displays time and date (same style as NEXTSTEP(tm) OS)"
HOMEPAGE="http://www.dockapps.net/wmclock"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

# Specific path for this version
S=${WORKDIR}/dockapps-daaf3aa

src_prepare() {
	eautoreconf
}
