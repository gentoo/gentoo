# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Library for some string essentials"
HOMEPAGE="https://libestr.adiscon.com/"
SRC_URI="https://libestr.adiscon.com/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa x86"
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable static-libs static)
		$(use_enable test testbench)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED%/}"/usr/lib* -name '*.la' -delete || die
}
