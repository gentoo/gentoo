# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dockable weather monitor for standard METAR stations using ICAO location"
HOMEPAGE="https://people.debian.org/~godisch/wmweather/"
SRC_URI="mirror://debian/pool/main/w/${PN}/${PN}_${PV}.orig.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libICE
	x11-apps/xmessage
	net-misc/curl"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=(
	"${WORKDIR}"/${P}/CHANGES
	"${WORKDIR}"/${P}/README
	)
