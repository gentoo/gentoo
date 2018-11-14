# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MY_PN="hardening-wrapper"

DESCRIPTION="Report the hardening characterists of a set of binaries"
HOMEPAGE="https://wiki.debian.org/Hardening https://packages.debian.org/source/jessie/hardening-wrapper"
SRC_URI="mirror://debian/pool/main/h/${MY_PN}/${MY_PN}_${PV}.tar.xz"

KEYWORDS="amd64 x86"
IUSE=""
LICENSE="GPL-2+"
SLOT="0"

DEPEND=""
RDEPEND=""

RESTRICT="test"

S="${WORKDIR}/${MY_PN}"

src_compile() { :; }

src_install() {
	newbin ${PN}.sh ${PN}
	dodoc AUTHORS
}
