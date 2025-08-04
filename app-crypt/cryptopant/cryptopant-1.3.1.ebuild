# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=cryptopANT
DESCRIPTION="C library for IP address anonymization using crypto-PAn algorithm"
HOMEPAGE="https://ant.isi.edu/software/cryptopANT/"
SRC_URI="https://ant.isi.edu/software/cryptopANT/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

# GPL-3+ for m4/ax_cflags_warn_all.m4
LICENSE="GPL-2 GPL-3+"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/openssl-3.0.0:="
DEPEND="${RDEPEND}"

src_configure() {
	econf --with-scramble_ips
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
