# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ library for semigroups and monoids"
HOMEPAGE="https://github.com/libsemigroups/libsemigroups"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

# Source headers have "or any later version"
LICENSE="GPL-3+"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_popcnt"

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		--disable-eigen \
		--disable-hpcombi \
		--disable-fmt
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
