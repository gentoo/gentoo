# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A dockapp for displaying data collected from METAR, AVN, ETA, and MRF forecasts"
HOMEPAGE="https://www.sourceforge.net/projects/wmweatherplus/"
SRC_URI="https://downloads.sourceforge.net/wmweatherplus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DEPEND="dev-libs/libpcre
	>=net-misc/curl-7.17.1
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libX11
	x11-wm/windowmaker"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-ar.patch
	"${FILESDIR}"/${P}-configure-clang16.patch
)

src_prepare() {
	default
	eautoreconf
}
