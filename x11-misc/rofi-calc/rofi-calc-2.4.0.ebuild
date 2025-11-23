# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Do live calculations in rofi!"
HOMEPAGE="https://github.com/svenstaro/rofi-calc"
SRC_URI="https://github.com/svenstaro/rofi-calc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# meson.build wants >=rofi-1.5.4, in fact it's 1.7.6.
# https://github.com/svenstaro/rofi-calc/issues/141
DEPEND="
	>=dev-libs/glib-2.40:2
	x11-libs/cairo
	>=x11-misc/rofi-1.7.6
"
RDEPEND="${DEPEND}
	sci-libs/libqalculate
"
BDEPEND="virtual/pkgconfig"

DOCS=( CHANGELOG.md README.md )
