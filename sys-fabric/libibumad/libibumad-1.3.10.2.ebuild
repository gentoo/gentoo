# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenIB User MAD lib functions which sit on top of the user MAD kernel modules"
HOMEPAGE="https://www.openfabrics.org"
LICENSE="|| ( BSD GPL-2 )"
SRC_URI="https://www.openfabrics.org/downloads/management/${P}.tar.gz"

SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="+pic static"

#DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable static)
		$(use_with pic)
	)

	econf "${myeconfargs[@]}"
}
