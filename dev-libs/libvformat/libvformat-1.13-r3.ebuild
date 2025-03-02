# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library to read and write vcard files"
HOMEPAGE="https://sourceforge.net/projects/vformat/"
SRC_URI="
	mirror://debian/pool/main/libv/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/libv/${PN}/${PN}_${PV}-12.debian.tar.xz
"
S="${WORKDIR}/${P}.orig"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 sparc x86"

src_prepare() {
	eapply \
		"${WORKDIR}"/debian/patches/*.patch \
		"${FILESDIR}"/${PN}-nodoc.patch \
		"${FILESDIR}"/${P}-has_unistd.patch \
		"${FILESDIR}"/${P}-str.patch \
		"${FILESDIR}"/${P}-time_t.patch

	default

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
