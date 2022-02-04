# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="IP Calculator prints broadcast/network/etc for an IP address and netmask"
LICENSE="GPL-2+"
HOMEPAGE="http://jodies.de/ipcalc"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"

RDEPEND=">=dev-lang/perl-5.6.0"
S=${WORKDIR}/${PN}-0.5

src_prepare() {
	eapply "${WORKDIR}"/debian/patches/*.patch
	eapply_user
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc changelog contributors README.md
}
