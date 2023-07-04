# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="The libupnpp C++ library wraps libupnp for easier use by upmpdcli and upplay"
HOMEPAGE="https://www.lesbonscomptes.com/upmpdcli"
SRC_URI="https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/expat
	net-libs/libnpupnp
	net-misc/curl
"
RDEPEND="${DEPEND}"

src_install() {
	default_src_install
	find "${ED}" -name '*.la' -delete || die "Couldn't delete .la files"
}
