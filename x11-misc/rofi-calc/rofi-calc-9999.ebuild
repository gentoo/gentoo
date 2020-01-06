# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 eutils autotools

DESCRIPTION="Do live calculations in rofi!"
HOMEPAGE="https://github.com/svenstaro/rofi-calc"
SRC_URI=""
EGIT_REPO_URI="https://github.com/svenstaro/rofi-calc.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=x11-misc/rofi-1.5
	>=sci-libs/libqalculate-2.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf -i
}
