# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="Do live calculations in rofi!"
HOMEPAGE="https://github.com/svenstaro/rofi-calc"
EGIT_REPO_URI="https://github.com/svenstaro/rofi-calc.git"

LICENSE="MIT"
SLOT="0"

DEPEND="
	x11-misc/rofi
	>=sci-libs/libqalculate-2.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf -i
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
