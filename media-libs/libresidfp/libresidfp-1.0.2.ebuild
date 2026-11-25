# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library to software emulation of the MOS 6581/8580 SID chip"
HOMEPAGE="https://github.com/libsidplayfp/libresidfp"
SRC_URI="https://github.com/libsidplayfp/libresidfp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local myeconfargs=(
		$(use_enable test tests)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
