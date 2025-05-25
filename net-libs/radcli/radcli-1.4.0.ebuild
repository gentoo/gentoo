# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple RADIUS client library"
HOMEPAGE="https://radcli.github.io/radcli/"
SRC_URI="https://github.com/radcli/radcli/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/6"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/nettle:=
	net-libs/gnutls:=
"
RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
