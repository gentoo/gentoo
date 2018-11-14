# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit flag-o-matic

DESCRIPTION="A dockapp for displaying data collected from METAR, AVN, ETA, and MRF forecasts"
HOMEPAGE="https://www.sourceforge.net/projects/wmweatherplus/"
SRC_URI="mirror://sourceforge/wmweatherplus/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/libpcre
	>=net-misc/curl-7.17.1
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libX11
	x11-wm/windowmaker"
RDEPEND="${DEPEND}"

src_configure() {
	append-flags "-fno-optimize-sibling-calls"
	econf
}

src_install() {
	dobin wmweather+
	dodoc ChangeLog HINTS README example.conf
	doman wmweather+.1
}
