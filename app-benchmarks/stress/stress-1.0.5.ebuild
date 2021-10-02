# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A deliberately simple workload generator for POSIX systems"
HOMEPAGE="https://salsa.debian.org/debian/stress"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="static"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable static)
	)

	econf "${myeconfargs[@]}"
}
