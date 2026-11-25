# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sidplay2 fork with resid-fp"
HOMEPAGE="https://github.com/libsidplayfp/sidplayfp"
SRC_URI="https://github.com/libsidplayfp/sidplayfp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsidplayfp:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
