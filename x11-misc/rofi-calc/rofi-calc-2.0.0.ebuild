# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Do live calculations in rofi!"
HOMEPAGE="https://github.com/svenstaro/rofi-calc"
SRC_URI="https://github.com/svenstaro/rofi-calc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	x11-misc/rofi
	>=sci-libs/libqalculate-2.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf -i
}
