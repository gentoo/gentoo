# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tool for extracting data from graphs"
HOMEPAGE="https://github.com/pn2200/g3data"
SRC_URI="https://github.com/pn2200/g3data/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-desktop-QA.patch )

src_prepare() {
	default

	eautoreconf
}
