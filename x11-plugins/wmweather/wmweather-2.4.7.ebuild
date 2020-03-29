# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a dockable weather monitor for standard METAR stations using ICAO location"
HOMEPAGE="https://people.debian.org/~godisch/wmweather/"
SRC_URI="mirror://debian/pool/main/w/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libICE
	x11-apps/xmessage
	net-misc/curl"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${P}/src

DOCS=(
	"${WORKDIR}"/${P}/CHANGES
	"${WORKDIR}"/${P}/README
	)

src_prepare() {
	default

	pushd "${WORKDIR}"/${P} || die
	eapply "${FILESDIR}"/${P}-fno-common.patch
}
