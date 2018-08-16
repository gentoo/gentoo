# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="a monitoring dockapp for system load, user amount, fork amount and processes"
HOMEPAGE="https://packages.qa.debian.org/w/wmmisc.html"
SRC_URI="mirror://debian/pool/main/w/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/${P}/src"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin ${PN}
	dodoc ../{ChangeLog,README}
}
