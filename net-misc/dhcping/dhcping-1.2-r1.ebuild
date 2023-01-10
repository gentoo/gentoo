# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Utility to send DHCP requests to DHCP servers to see if responding"
HOMEPAGE="http://www.mavetju.org/unix/general.php"
SRC_URI="http://www.mavetju.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

src_prepare() {
	default

	# Clang 16
	eautoreconf
}
