# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="LV2 port of the MDA plugins by Paul Kellett"
HOMEPAGE="https://drobilla.net/software/mda-lv2.html"
SRC_URI="https://download.drobilla.net/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="media-libs/lv2"
