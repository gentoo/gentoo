# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Enlightenment image viewer written with EFL"
HOMEPAGE="https://www.enlightenment.org/about-ephoto"
SRC_URI="https://download.enlightenment.org/rel/apps/ephoto/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-libs/efl-1.26.1[eet,X]
	media-libs/libexif"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
