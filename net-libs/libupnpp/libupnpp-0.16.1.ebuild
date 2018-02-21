# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DESCRIPTION="The libupnpp C++ library wraps libupnp for easier use by upmpdcli and upplay"
HOMEPAGE="http://www.lesbonscomptes.com/upmpdcli"
SRC_URI="https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

# Unfortunatetly I receive segfaults from upmpcli on any newer version
DEPEND="
	dev-libs/expat
	<net-libs/libupnp-1.6.24
	net-misc/curl
"
RDEPEND="${DEPEND}"
