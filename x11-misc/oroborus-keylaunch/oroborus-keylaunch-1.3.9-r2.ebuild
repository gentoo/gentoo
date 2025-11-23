# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_AUTOMAKE=none
inherit autotools

MY_PN=${PN/oroborus-//}

DESCRIPTION="utility for binding keys in Oroborus"
HOMEPAGE="https://www.oroborus.org"
SRC_URI="mirror://debian/pool/main/k/${MY_PN}/${MY_PN}_${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )
DOCS=( README docs/example_rc debian/changelog )

src_prepare() {
	default
	eautoconf # bug 898254
}
