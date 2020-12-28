# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="The libupnpp C++ library wraps libupnp for easier use by upmpdcli and upplay"
HOMEPAGE="https://www.lesbonscomptes.com/upmpdcli"
SRC_URI="https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/expat
	>=net-libs/libnpupnp-4.0.14-r1
	net-misc/curl
"
RDEPEND="${DEPEND}"
